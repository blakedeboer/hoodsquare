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


end

