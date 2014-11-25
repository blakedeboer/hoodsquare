require 'k_means'

class Tag < ActiveRecord::Base
  belongs_to :tagger, :class_name => :hood
  belongs_to :taggee, :class_name => :hood
  
  def self.k_means
    data = [[1,1], [1,2], [1,1], [1000, 1000], [500, 500]]
    kmeans = KMeans.new(data, :centroids => 2)
  end 


end
