require 'k_means'

class Tag < ActiveRecord::Base
  belongs_to :tagger, :class_name => :hood
  belongs_to :taggee, :class_name => :hood

  #pulls data from comparison analysis and converts it to tags in db
  def self.create_tags_from_comparison(hood, comparison)
    # comparison is array passed in from method that returns top comparisons as well as hood being compared
    #allows user votes to be incorporated easily with the comparison so that over time user votes
    #will overtake the comparison and be the predominant deciding force
    #takes the biggest match and creates 10 tags for it so that it has the highest percentage
    10.times do 
      Tag.create(:tagger_id => comparison[0].id, :taggee_id => hood.id)
    end
    #creates 5 tags for the second match so it shows with second highest percentage
    5.times do 
      Tag.create(:tagger_id => comparison[1].id, :taggee_id => hood.id)
    end
    #create 3 tags for the third match so it shows up with lowest percentage
    3.times do 
      Tag.create(:tagger_id => comparison[2].id, :taggee_id => hood.id)
    end
  end
  
  def self.k_means
    data = [[1,1], [1,2], [1,1], [1000, 1000], [500, 500]]
    kmeans = KMeans.new(data, :centroids => 2)
  end 


end
