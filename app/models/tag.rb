class Tag < ActiveRecord::Base
  belongs_to :tagger, :class_name => :hood
  belongs_to :taggee, :class_name => :hood

  #pulls data from comparison analysis and converts it to tags in db
  def self.create_tags_from_comparison(hood_id, comparison_ids)
    # comparison is array passed in from method that returns top comparisons as well as hood being compared
    #allows user votes to be incorporated easily with the comparison so that over time user votes
    #will overtake the comparison and be the predominant deciding force
    #takes the biggest match and creates 10 tags for it so that it has the highest percentage
    10.times do 
      Tag.create(:tagger_id => comparison_ids[0], :taggee_id => hood_id)
    end
    #creates 5 tags for the second match so it shows with second highest percentage
    5.times do 
      Tag.create(:tagger_id => comparison_ids[1], :taggee_id => hood_id)
    end
    #create 3 tags for the third match so it shows up with lowest percentage
    3.times do 
      Tag.create(:tagger_id => comparison_ids[2], :taggee_id => hood_id)
    end
  end
  


end
