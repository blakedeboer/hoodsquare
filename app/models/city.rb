require 'open-uri'
require 'json'

class City < ActiveRecord::Base
  has_many :hoods

  ALL_HOODS = ["The Mission District", "Fisherman's Wharf", "The Castro", "SOMA", "Downtown San Francisco", "Financial District", "Hayes Valley", "The Tenderloin", "Japantown", "Pacific Heights", "Civic Center District", "Chinatown", "Outer Sunset", "North Beach", "Haight-Ashbury", "City of Sausalito", "The Marina District", "Downtown Oakland", "Russian Hill", "The Inner Sunset", "Downtown Berkeley", "West Oakland", "Bernal Heights",  "Twin Peaks", "Chelsea", "Midtown Manhattan", "Flatiron District", "Theater District", "Hell's Kitchen", "SoHo", "West Village", "Greenwich Village", "Williamsburg", "Upper East Side", "Lower East Side", "East Village", "Upper West Side", "TriBeCa", "Harlem", "Chinatown", "Financial District", "Meatpacking District", "Park Slope", "Brooklyn Heights", "Fort Greene", "Murray Hill"]

  # makes an api call with the foursquare api and parses it - can get the name of the hood and the latitude and longitudes and other info
  def nychoods
    html = open("https://api.foursquare.com/v2/venues/search?client_secret=PHS43OQF2D0HAKGLZPICYOGG0ZPFEIXLAYIKNRMXIDBJ1TWC&client_id=RMTXBZI1NAX1VZ5RZVQLPOVGLYH2XG1CGT4X5XJJAZPS0JBE&limit=50&venuePhotos=1&v=20140327&near=New%20York,NY&radius=40000&categoryId=4f2a25ac4b909258e854f55f")
    @file = File.read(html)
    hood_hsh = JSON.parse(@file)
    nyc = City.find_by(:name => "New York City")
    hood_hsh["response"]["venues"].each do |venue|
      if ALL_HOODS.include?(venue["name"])
        nyc.hoods.create(:name => venue["name"], :latlng => "#{venue["location"]["lat"]}, #{venue["location"]["lng"]}")
      end
    end
  end

  # makes an api call with the foursquare api and parses it - can get the name of the hood and the latitude and longitudes and other info
  def sfhoods
    html = open("https://api.foursquare.com/v2/venues/search?client_secret=PHS43OQF2D0HAKGLZPICYOGG0ZPFEIXLAYIKNRMXIDBJ1TWC&client_id=RMTXBZI1NAX1VZ5RZVQLPOVGLYH2XG1CGT4X5XJJAZPS0JBE&limit=50&venuePhotos=1&v=20140327&near=San%20Francisco,CA&radius=40000&categoryId=4f2a25ac4b909258e854f55f")
    @file = File.read(html)
    hood_hsh = JSON.parse(@file)
    sf = City.find_by(:name => "San Francisco")
    hood_hsh["response"]["venues"].each do |venue|
      if ALL_HOODS.include?(venue["name"])
        sf.hoods.create(:name => venue["name"], :latlng => "#{venue["location"]["lat"]}, #{venue["location"]["lng"]}")
      end
    end
  end

  def nickname
    self.name.split(" ").collect do |word|
      word[0].upcase
    end.join("")
  end

end
