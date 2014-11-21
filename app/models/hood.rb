require 'open-uri'
require 'json'

class Hood < ActiveRecord::Base
  belongs_to :city
  has_many :tags, :foreign_key => 'tagger_id'
  has_many :tags, :foreign_key => 'taggee_id'

  #instantiate a client with our foursquare_id and foursquare_secret
  @client = Foursquare2::Client.new(:client_id => ENV['foursquare_id'], :client_secret => ENV['foursquare_secret'], :api_version => '20140806')

  #for now this returns 50 ids of the stores in soho
  def self.search
    @client.search_venues(:ll => '40.7231, -74.0008', :llAcc => '300', :limit => '50').venues.map{|i| i.id}
  end

  # makes an api call with the foursquare api and parses it - can get the name of the hood and the latitude and longitudes and other info
  def self.nychoods
    html = open("https://api.foursquare.com/v2/venues/search?client_secret=4UPEJ0UD33I0UC2SX2IE3FOHOCERWWVMIIINPH1CET1UCZHY&client_id=GOQ00FEJWU4XVJVSH1W0CBRUVTIJQYIBRXBXDF2K4N1UOIG0&limit=50&venuePhotos=1&v=20140327&near=New%20York,NY&radius=40000&categoryId=4f2a25ac4b909258e854f55f")
    @file = File.read(html)
    hood_hsh = JSON.parse(@file)
  end

  # returns a hash of all venues in hood: {venue id => [venue name, venue address]}
  # SoHo radius - 250
  def self.venue_names_addresses(radius, limit)
    venues ={}
    results = @client.explore_venues(:ll => '40.7231,-74.0008', :radius => "#{radius}", :limit => "#{limit}")
    results["groups"][0]["items"].each do |v|
      venues[v.venue.id] = [v.venue.name, v.venue.location.address]
    end
    venues
  end

  #returns all venue ids for a neighbodhood given a radius(m) and limit
  def self.venue_ids(radius, limit)
    results = @client.explore_venues(:ll => '40.7231,-74.0008', :radius => "#{radius}", :limit => "#{limit}")
    results["groups"][0]["items"].map {|v| v.venue.id}
  end

  def self.venue_info(venue_id)
    venue = @client.venue(venue_id)
    info = {}
    info[:category_id] = venue.categories.first.id
    info[:category_name] = venue.categories.first.name
    info[:total_checkins] = venue.stats.checkinsCount
    info
  end

  #returns nested hashes of all categories
  def self.all_categories
    html = open("https://api.foursquare.com/v2/venues/categories?client_secret=4UPEJ0UD33I0UC2SX2IE3FOHOCERWWVMIIINPH1CET1UCZHY&client_id=GOQ00FEJWU4XVJVSH1W0CBRUVTIJQYIBRXBXDF2K4N1UOIG0&v=20140327&categoryId=4f2a25ac4b909258e854f55f")
    @file = File.read(html)
    hood_hsh = JSON.parse(@file)
  end

  #returns an array of all category names
  def self.all_cat_names
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



end

