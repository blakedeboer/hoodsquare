require 'open-uri'
require 'json'

class Hood < ActiveRecord::Base
  belongs_to :city
  has_many :tags, :foreign_key => 'tagger_id'
  has_many :tags, :foreign_key => 'taggee_id'

  def self.nychoods
    html = open("https://api.foursquare.com/v2/venues/search?client_secret=4UPEJ0UD33I0UC2SX2IE3FOHOCERWWVMIIINPH1CET1UCZHY&client_id=GOQ00FEJWU4XVJVSH1W0CBRUVTIJQYIBRXBXDF2K4N1UOIG0&limit=50&venuePhotos=1&v=20140327&near=New%20York,NY&radius=40000&categoryId=4f2a25ac4b909258e854f55f")
    @file = File.read(html)
    hood_hsh = JSON.parse(@file)
  end

  # def self.trial_explore
  #   html = open("https://api.foursquare.com/v2/venues/search?client_secret=4UPEJ0UD33I0UC2SX2IE3FOHOCERWWVMIIINPH1CET1UCZHY&client_id=GOQ00FEJWU4XVJVSH1W0CBRUVTIJQYIBRXBXDF2K4N1UOIG0&limit=50&v=20140327&&near=Soho,%20NY")
  #   @file = File.read(html)
  #   JSON.parse(@file)
  # end

end

