class Tag < ActiveRecord::Base
  belongs_to :tagger, :class_name => :hood
  belongs_to :taggee, :class_name => :hood

  #pulls data from comparison analysis and converts it to tags in db
  def self.create_tags_from_comparison(hood, comparison)
    # comparison is array passed in from method that returns top comparisons as well as hood being compared
    10.times do 
      Tag.create(:tagger_id => comparison[0].id, :taggee_id => hood.id)
    end

    5.times do 
      Tag.create(:tagger_id => comparison[1].id, :taggee_id => hood.id)
    end

    3.times do 
      Tag.create(:tagger_id => comparison[2].id, :taggee_id => hood.id)
    end
  end
  
end
