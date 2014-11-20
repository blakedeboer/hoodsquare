# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

nyc = City.create(:name => "New York City")
sf = City.create(:name => "San Francisco")

nyc.hoods.create(:name => "SoHo") #1
nyc.hoods.create(:name => "Williamsburg") #2
nyc.hoods.create(:name => "Financial District") #3
nyc.hoods.create(:name => "Times Square") #4


sf.hoods.create(:name => "The Mission") #5
sf.hoods.create(:name => "Downtown") #6
sf.hoods.create(:name => "Fisherman's Wharf") #7
sf.hoods.create(:name => "North Beach") #8



Tag.create(:tagger_id => 1, :taggee_id => 8)
Tag.create(:tagger_id => 1, :taggee_id => 8)
Tag.create(:tagger_id => 1, :taggee_id => 8)
Tag.create(:tagger_id => 1, :taggee_id => 8)

Tag.create(:tagger_id => 1, :taggee_id => 5)
Tag.create(:tagger_id => 1, :taggee_id => 5)
Tag.create(:tagger_id => 1, :taggee_id => 5)

Tag.create(:tagger_id => 1, :taggee_id => 6)


Tag.create(:tagger_id => 8, :taggee_id => 1)
Tag.create(:tagger_id => 8, :taggee_id => 1)
Tag.create(:tagger_id => 8, :taggee_id => 1)

Tag.create(:tagger_id => 8, :taggee_id => 2)

