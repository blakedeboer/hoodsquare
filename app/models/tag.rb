require 'k_means'

class Tag < ActiveRecord::Base
  belongs_to :tagger, :class_name => :hood
  belongs_to :taggee, :class_name => :hood
  
  def 
end
