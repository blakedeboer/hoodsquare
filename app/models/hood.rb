require 'open-uri'
require 'json'

class Hood < ActiveRecord::Base
  belongs_to :city
  has_many :tags, :foreign_key => 'tagger_id'
  has_many :tags, :foreign_key => 'taggee_id'
  has_many :categories

  #creates a new instance of FourSquare2 gem for searches
  def self.foursquare
    @@client ||= Foursquare2::Client.new(:client_id => ENV['foursquare_id'], :client_secret => ENV['foursquare_secret'], :api_version => '20140806')
  end

  #does a search of a certain hood's latlng with radius of 300m and limit of 50 venues
  def search
    self.class.foursquare.search_venues(:ll => "#{self.latlng}", :llAcc => '300', :limit => '50').venues.map{|i| i.id}
  end

  # returns a hash of all venues in hood: {venue id => [venue name, venue address]}
  # SoHo radius - 250
  def venue_names_addresses(radius, limit)
    venues ={}
    results = self.class.foursquare.explore_venues(:ll => "#{self.latlng}", :radius => "#{radius}", :limit => "#{limit}")
    results["groups"][0]["items"].each do |v|
      venues[v.venue.id] = [v.venue.name, v.venue.location.address]
    end
    venues
  end

  #returns hash of venue id, name, checkins
  def venue_info(venue_id)
    venue = self.class.foursquare.venue(venue_id)
    info = {}
    info[:category_id] = venue.categories.first.id
    info[:category_name] = venue.categories.first.name
    info[:total_checkins] = venue.stats.checkinsCount
    info
  end

  #returns nested hashes of all categories
  def all_categories
    html = open("https://api.foursquare.com/v2/venues/categories?client_secret=4UPEJ0UD33I0UC2SX2IE3FOHOCERWWVMIIINPH1CET1UCZHY&client_id=GOQ00FEJWU4XVJVSH1W0CBRUVTIJQYIBRXBXDF2K4N1UOIG0&v=20140327&categoryId=4f2a25ac4b909258e854f55f")
    @file = File.read(html)
    category_hsh = JSON.parse(@file)
  end

  #returns an array of all category names
  def all_cat_names
    names = all_categories["response"]["categories"].map do |cat|
      cat["categories"].map do |subc|
        if subc["categories"].count > 0
          array = subc["categories"].map {|ssc| ssc["name"]}
          [subc["name"], array]
        else 
          subc["name"]
        end
      end
    end
    names.flatten
  end

  #returns only 1st or 2nd level category
  def parent_cat(cat_id)
    category_id = ""
    names = all_categories["response"]["categories"].each do |cat|
      if cat["id"] == cat_id
        category_id = cat["id"]
      elsif
        cat["categories"].each do |subc|
          if subc["id"] == cat_id
            category_id = subc["id"]
          elsif subc["categories"].count > 0
            subc["categories"].each do |ssc|
              if ssc["id"] == cat_id
                category_id = subc["id"]
              end
            end
          end
        end
      end
    end
    category_id
  end

  #returns the category name given a category id
  def cat_name(cat_id)
    category_name = ""
    all_categories["response"]["categories"].each do |cat|
      if cat["id"] == cat_id
        category_name = cat["name"]
      elsif
        cat["categories"].each do |subc|
          if subc["id"] == cat_id
            category_name = subc["name"]
          elsif subc["categories"].count > 0
            subc["categories"].each do |ssc|
              if ssc["id"] == cat_id
                category_name = ssc["name"]
              end
            end
          end
        end
      end
    end
    category_name
  end

  #returns hash with one key-value pair of parent id and total checkins
  def venue_cat_checkins(venue_id)
    venue = self.class.foursquare.venue(venue_id)
    info = {}
    parent_id = parent_cat(venue.categories.first.id)
    info[parent_id] = venue.stats.checkinsCount
    info
  end

  #returns an array of hashes(parent_id => checkins) given a radius(m) and limit(count)
  def hood_categories(radius, limit)
    results = self.class.foursquare.explore_venues(:ll => "#{self.latlng}", :radius => "#{radius}", :limit => "#{limit}")
    id_array = results["groups"][0]["items"].map {|v| v.venue.id}
    id_array.map do |venue| 
      venue_cat_checkins(venue)
    end
  end

  # returns consolidated hash of {parent_category => total checkins}
  def hood_checkins
    cat_checkins = {}
    hood_cats = hood_categories(250, 100)
    hood_cats.each do |cat_hsh|
      cat = cat_hsh.keys.first
      checkin = cat_hsh.values.first
      if cat_checkins[cat]
        cat_checkins[cat] += checkin
      else
        cat_checkins[cat] = checkin
      end
    end
    cat_checkins
  end

  #creates instances of Category in database for a specific hood
  def create_hood_cats
    hood_checkins.each do |cat, checkins|
      name = self.cat_name(cat)
      self.categories.create(:cat_id => cat, :cat_name => name, :checkins => checkins)
    end
  end

  def cat_name_and_checkin
    all_categories_array = self.categories.order(checkins: :desc).limit(10)
    all_categories_array.each do |cat|
      puts "cat name: #{cat.cat_name}"
      puts "cat count: #{cat.checkins}"
    end
  end

  #returns hash of a hood's category names and percentage of total checkins {"category name" => 0.05} 
  def category_name_percentage_hash
    total_checkins = 0.0
    self.categories.find_each do |category|
      total_checkins += category.checkins
    end
    cat_percentage_hash = {}
    all_categories_array = self.categories.order(checkins: :desc)
    all_categories_array.each do |category|
      percentage = category.checkins / total_checkins
      cat_percentage_hash[category.cat_name] = percentage
    end
    cat_percentage_hash
  end

  #returns hash of a hood's category ids and percentage of total checkins {"category id" => 0.05} 
  def category_id_percentage_hash
    total_checkins = 0.0
    self.categories.find_each do |category|
      total_checkins += category.checkins
    end
    cat_percentage_hash = {}
    all_categories_array = self.categories.order(checkins: :desc)
    all_categories_array.each do |category|
      percentage = category.checkins / total_checkins
      cat_percentage_hash[category.cat_id] = percentage
    end
    cat_percentage_hash
  end


  def nickname
    "#{self.name.split(" ").join("_")}_#{self.city.nickname}"
  end


  #returns array of percentages for all most_popular categories [0.05, 0.09, 0.0, 0.7]
  #if a hood does not have any checkins for that category, it is represented at 0.0 in the array
  def array_of_category_percents
    hash_most_pop_categories = Category.most_popular_by_count(3)
    array = hash_most_pop_categories.keys.map do |category_name|
      if self.category_name_percentage_hash.keys.include?(category_name)
        self.category_name_percentage_hash.select {|k, v| k == category_name}
      else
        {category_name => 0.0}
      end
    end
    array.map do |category|
      category.values.first
    end
  end

  def self.sf_hood_category_count
    Hood.where(:city_id => 2).each do |hood|
      if hood.categories.count > 21
        puts "#{hood.name}: #{hood.categories.count}"
      end
    end
  end

  def self.distance(current_hood_id, comparison_hood_id)
    current_hood_array = self.find(current_hood_id).array_of_category_percents
    comp_hood_array = self.find(comparison_hood_id).array_of_category_percents
    data = [current_hood_array, comp_hood_array]
    distances_array = [0, 0]
    accurate = false
    accurate_distance = 0

    while !accurate
      kmeans = KMeans.new(data, :centroids => 2)
      if kmeans.view.last.count == 2
        if kmeans.nodes.first.best_distance == kmeans.nodes.last.best_distance 
          accurate_distance = kmeans.nodes.first.best_distance
          accurate = true
        elsif distances_array.include?(kmeans.nodes.first.best_distance) 
          accurate_distance = kmeans.nodes.first.best_distance
          accurate = true
        elsif distances_array.include?(kmeans.nodes.last.best_distance)
          accurate_distance = kmeans.nodes.last.best_distance
          accurate = true
        else
          distances_array = [kmeans.nodes.first.best_distance, kmeans.nodes.last.best_distance]
        end
      end
    end
    accurate_distance
  end 

  def self.relative_distances(current_hood_id, city_id)
    distances_hash = {}

    Hood.where(:city_id => city_id).each do |hood|
      distances_hash[hood.name] = [self.distance(current_hood_id, hood.id)]
    end
    distances_hash.sort_by {|k, v| v}
  end



end #end of class


