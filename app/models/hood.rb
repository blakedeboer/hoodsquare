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

  #returns key-value pair of parent id and total checkins
  def venue_cat_checkins(venue_id)
    venue = self.class.foursquare.venue(venue_id)
    info = {}
    parent_id = parent_cat(venue.categories.first.id)
    info[parent_id] = venue.stats.checkinsCount
    info
  end

  #returns all venue ids for a neighbodhood given a radius(m) and limit
  def hood_categories(radius, limit)
    results = self.class.foursquare.explore_venues(:ll => "#{self.latlng}", :radius => "#{radius}", :limit => "#{limit}")
    id_array = results["groups"][0]["items"].map {|v| v.venue.id}
    id_array.map do |venue| 
      venue_cat_checkins(venue)
    end
  end

  # returns consolidated list of categories with total checkins across those 
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
      self.categories.create(:cat_id => cat, :checkins => checkins)
    end
  end

  def nickname
    "#{self.name.split(" ").join("_")}_#{self.city.nickname}"
  end

  def get_flickr_img
    lat = self.latlng.split(',').first.strip.to_f.round(1)
    lng = self.latlng.split(',').last.strip.to_f.round(1)
    #find place id with lat and long
    location = "https://api.flickr.com/services/rest/?method=flickr.places.findByLatLon&api_key=3343b0e670d14fb911f614f42f021a7b&lat=#{lat}&lon=#{lng}&is_commons=true&format=json&nojsoncallback=1"
    # 
    # &geo_context=2

    json_results = open(location)
    images = JSON.load(json_results)
    place_id = images['places']['place'][0]['place_id']
    # binding.pry

    # url = "https://api.flickr.com/services/rest/?format=json&method=flickr.photos.search&api_key=" + ENV['flickr_id'] + "&text=" + self.city.name.downcase.gsub(' ','+') + '%2C+' + self.name.downcase.gsub(' ','+') + '&sort=relevance&tag_mode=all&safe_search=1&content_type=1&place_id=' + place_id + '&nojsoncallback=1'

    # withouot place_id
    url = "https://api.flickr.com/services/rest/?format=json&method=flickr.photos.search&api_key=" + ENV['flickr_id'] + "&text=" + self.name.downcase.gsub(' ','+') + '%2C+' + self.city.name.downcase.gsub(' ','+') + '&sort=interestingness-desc&safe_search=1&content_type=1&' + '&nojsoncallback=1'

    json_results = open(url)
    images = JSON.load(json_results)
    photo = images['photos']['photo'][0]
    farm_id = photo['farm']
    server_id = photo['server']
    id = photo['id']
    secret = photo['secret']

    link = "https://farm#{farm_id}.staticflickr.com/#{server_id}/#{id}_#{secret}.jpg"
    binding.pry
  end

  def self.get_img_urls
    self.all.each do |hood|
      # if hood.image_url == nil
        photo = hood.get_flickr_img
        hood.update(:image_url => photo)
      # end
    end
  end

end #end of class


