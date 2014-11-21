require 'open-uri'
require 'json'

class Hood < ActiveRecord::Base
  belongs_to :city
  has_many :tags, :foreign_key => 'tagger_id'
  has_many :tags, :foreign_key => 'taggee_id'

  def self.foursquare
    @@client ||= Foursquare2::Client.new(:client_id => ENV['foursquare_id'], :client_secret => ENV['foursquare_secret'], :api_version => '20140806')
  end

  def search
    self.class.foursquare.search_venues(:ll => '40.7231, -74.0008', :llAcc => '300', :limit => '50').venues.map{|i| i.id}
  end

  # makes an api call with the foursquare api and parses it - can get the name of the hood and the latitude and longitudes and other info
  def nychoods
    html = open("https://api.foursquare.com/v2/venues/search?client_secret=4UPEJ0UD33I0UC2SX2IE3FOHOCERWWVMIIINPH1CET1UCZHY&client_id=GOQ00FEJWU4XVJVSH1W0CBRUVTIJQYIBRXBXDF2K4N1UOIG0&limit=50&venuePhotos=1&v=20140327&near=New%20York,NY&radius=40000&categoryId=4f2a25ac4b909258e854f55f")
    @file = File.read(html)
    hood_hsh = JSON.parse(@file)
    nyc = City.find_by(:name => "New York City")
    hood_hsh["response"]["venues"].each do |venue|
      nyc.hoods.create(:name => venue["name"], :latlng => "#{venue["location"]["lat"]}, #{venue["location"]["lng"]}")
    end
  end

  # returns a hash of all venues in hood: {venue id => [venue name, venue address]}
  # SoHo radius - 250
  def venue_names_addresses(radius, limit)
    venues ={}
    results = @client.explore_venues(:ll => '40.7231,-74.0008', :radius => "#{radius}", :limit => "#{limit}")
    results["groups"][0]["items"].each do |v|
      venues[v.venue.id] = [v.venue.name, v.venue.location.address]
    end
    venues
  end

  #returns all venue ids for a neighbodhood given a radius(m) and limit
  def hood_venues(radius, limit)
    results = self.class.foursquare.explore_venues(:ll => '40.7231,-74.0008', :radius => "#{radius}", :limit => "#{limit}")
    id_array = results["groups"][0]["items"].map {|v| v.venue.id}
    id_array.map do |venue| 
      Hood.venue_cat_checkins(venue)
    end
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
    hood_hsh = JSON.parse(@file)
  end

  #returns an array of all category names
  def all_cat_names
    names = Hood.all_categories["response"]["categories"].map do |cat|
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
  def self.parent_cat(cat_id)
    category_id = ""
    names = Hood.all_categories["response"]["categories"].each do |cat|
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
  def self.venue_cat_checkins(venue_id)
    venue = self.class.foursquare.venue(venue_id)
    info = {}
    parent_id = Hood.parent_cat(venue.categories.first.id)
    info[parent_id] = venue.stats.checkinsCount
    info
  end

  # makes an api call with the foursquare api and parses it - can get the name of the hood and the latitude and longitudes and other info
  def self.sfhoods
    html = open("https://api.foursquare.com/v2/venues/search?client_secret=4UPEJ0UD33I0UC2SX2IE3FOHOCERWWVMIIINPH1CET1UCZHY&client_id=GOQ00FEJWU4XVJVSH1W0CBRUVTIJQYIBRXBXDF2K4N1UOIG0&limit=50&venuePhotos=1&v=20140327&near=San%20Francisco,CA&radius=40000&categoryId=4f2a25ac4b909258e854f55f")
    @file = File.read(html)
    hood_hsh = JSON.parse(@file)
    sf = City.find_by(:name => "San Francisco")
    hood_hsh["response"]["venues"].each do |venue|
      sf.hoods.create(:name => venue["name"], :latlng => "#{venue["location"]["lat"]}, #{venue["location"]["lng"]}")
    end
  end

end


