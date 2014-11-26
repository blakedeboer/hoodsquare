require 'k_means'

class Tag < ActiveRecord::Base
  belongs_to :tagger, :class_name => :hood
  belongs_to :taggee, :class_name => :hood
  
  def self.k_means
    data = [[1,1], [1,2], [1,1], [1000, 1000], [500, 500]]
    kmeans = KMeans.new(data, :centroids => 2)
  end 

  def self.distance(current_hood_id, comparison_hood_id)
    current_hood_array = Hood.find(current_hood_id).array_of_category_percents
    comp_hood_array = Hood.find(comparison_hood_id).array_of_category_percents
    data = [current_hood_array, comp_hood_array]
    distances_array = [0, 0]
    accurate = false
    accurate_distance = 0

    while !accurate
      kmeans = KMeans.new(data, :centroids => 2)
      if kmeans.view.last.count == 2
        if kmeans.nodes.first.best_distance == kmeans.nodes.last.best_distance 
          accurate_distance = kmeans.nodes.first.best_distance
          accurate = true
        elsif distances_array.include?(kmeans.nodes.first.best_distance) 
          accurate_distance = kmeans.nodes.first.best_distance
          accurate = true
        elsif distances_array.include?(kmeans.nodes.last.best_distance)
          accurate_distance = kmeans.nodes.last.best_distance
          accurate = true
        else
          distances_array = [kmeans.nodes.first.best_distance, kmeans.nodes.last.best_distance]
        end
      end
    end
    accurate_distance
  end 


end
