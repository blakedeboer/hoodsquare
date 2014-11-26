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

# w_burg = Hood.find_by(:name => "Williamsburg")
# w_burg.create_hood_cats

# soma = Hood.find_by(:name => "SOMA")
# soma.create_hood_cats

# mission = Hood.find_by(:name => "The Mission District")
# soho = Hood.find_by(:name => "SoHo")

# soho = Hood.find_by(:name => "SoHo")
# soho.create_hood_cats

# mission = Hood.find_by(:name => "The Mission District")
# mission.create_hood_cats

# soma = Hood.find_by(:name => "SOMA")
# soma.create_hood_cats

nyc.hoods.each do |hood|
  hood.create_hood_cats
end

sf.hoods.each do |hood|
  hood.create_hood_cats
end

nyc.hoods.each do |hood|
  distance_hash = Hood.relative_distances_by_id(hood.id, 2)
  comparison_array = distance_hash.map do |hood_id, hood_distance|
    hood_id
  end
  Tag.create_tags_from_comparison(hood.id, comparison_array)
end

sf.hoods.each do |hood|
  distance_hash = Hood.relative_distances_by_id(hood.id, 1)
  comparison_array = distance_hash.map do |hood_id, hood_distance|
    hood_id
  end
  Tag.create_tags_from_comparison(hood.id, comparison_array)
end

# w_comparison = [Hood.find_by(:name => "The Mission District"), Hood.find_by(:name => "North Beach"), Hood.find_by(:name => "Haight-Ashbury")]
# soma_comparison = [Hood.find_by(:name => "SoHo"), Hood.find_by(:name => "Chelsea"), Hood.find_by(:name => "East Village")]
# mission_comparison = [Hood.find_by(:name => "Williamsburg"), Hood.find_by(:name => "East Village"), Hood.find_by(:name => "Park Slope")]
# soho_comparison = [Hood.find_by(:name => "SOMA"), Hood.find_by(:name => "Downtown San Francisco"), Hood.find_by(:name => "The Castro")]
# Tag.create_tags_from_comparison(w_burg, w_comparison)
# Tag.create_tags_from_comparison(soma, soma_comparison)
# Tag.create_tags_from_comparison(mission, mission_comparison)
# Tag.create_tags_from_comparison(soho, mission_comparison)


