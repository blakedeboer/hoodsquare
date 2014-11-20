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
    nyc = City.find_by(:name => "New York City")
    hood_hsh["response"]["venues"].each do |venue|
      nyc.hoods.create(:name => venue["name"], :latlng => "#{venue["location"]["lat"]}, #{venue["location"]["lng"]}")
    end
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


  # def self.trial_explore
  #   html = open("https://api.foursquare.com/v2/venues/search?client_secret=4UPEJ0UD33I0UC2SX2IE3FOHOCERWWVMIIINPH1CET1UCZHY&client_id=GOQ00FEJWU4XVJVSH1W0CBRUVTIJQYIBRXBXDF2K4N1UOIG0&limit=50&v=20140327&&near=Soho,%20NY")
  #   @file = File.read(html)
  #   JSON.parse(@file)
  # end

end

