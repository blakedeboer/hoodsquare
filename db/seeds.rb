# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

nyc = City.create(:name => "New York City")
sf = City.create(:name => "San Francisco")

nyc.nychoods
sf.sfhoods

# soho = Hood.find_by(:name => "SoHo")
# soho.create_hood_cats

# mission = Hood.find_by(:name => "The Mission District")
# mission.create_hood_cats

soma = Hood.find_by(:name => "SOMA")
soma.create_hood_cats

# nyc.hoods.each do |hood|
#   hood.create_hood_cats
# end

# sf.hoods.each do |hood|
#   hood.create_hood_cats
# end

# Tag.create(:tagger_id => 1, :taggee_id => 8)
# Tag.create(:tagger_id => 1, :taggee_id => 8)
# Tag.create(:tagger_id => 1, :taggee_id => 8)
# Tag.create(:tagger_id => 1, :taggee_id => 8)



# Tag.create(:tagger_id => 8, :taggee_id => 2)



