require 'open-uri'
require 'json'

class City < ActiveRecord::Base
  has_many :hoods

  # makes an api call with the foursquare api and parses it - can get the name of the hood and the latitude and longitudes and other info
  def nychoods
    html = open("https://api.foursquare.com/v2/venues/search?client_secret=PHS43OQF2D0HAKGLZPICYOGG0ZPFEIXLAYIKNRMXIDBJ1TWC&client_id=RMTXBZI1NAX1VZ5RZVQLPOVGLYH2XG1CGT4X5XJJAZPS0JBE&limit=50&venuePhotos=1&v=20140327&near=New%20York,NY&radius=40000&categoryId=4f2a25ac4b909258e854f55f")
    @file = File.read(html)
    hood_hsh = JSON.parse(@file)
    nyc = City.find_by(:name => "New York City")
    hood_hsh["response"]["venues"].each do |venue|
      nyc.hoods.create(:name => venue["name"], :latlng => "#{venue["location"]["lat"]}, #{venue["location"]["lng"]}")
    end
  end

  # makes an api call with the foursquare api and parses it - can get the name of the hood and the latitude and longitudes and other info
  def sfhoods
    html = open("https://api.foursquare.com/v2/venues/search?client_secret=PHS43OQF2D0HAKGLZPICYOGG0ZPFEIXLAYIKNRMXIDBJ1TWC&client_id=RMTXBZI1NAX1VZ5RZVQLPOVGLYH2XG1CGT4X5XJJAZPS0JBE&limit=50&venuePhotos=1&v=20140327&near=San%20Francisco,CA&radius=40000&categoryId=4f2a25ac4b909258e854f55f")
    @file = File.read(html)
    hood_hsh = JSON.parse(@file)
    sf = City.find_by(:name => "San Francisco")
    hood_hsh["response"]["venues"].each do |venue|
      sf.hoods.create(:name => venue["name"], :latlng => "#{venue["location"]["lat"]}, #{venue["location"]["lng"]}")
    end
  end

end
