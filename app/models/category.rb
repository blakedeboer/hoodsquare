class Category < ActiveRecord::Base
  belongs_to :hood

  #returns all cat_ids
  def self.all_cat_ids
    all_cat_ids = []
    self.all.find_each do |c|
      unless all_cat_ids.include?(c.cat_id)
       all_cat_ids << c.cat_id
      end
    end
    all_cat_ids 
  end

  #DO NOT USE. returns the top fifty categories, but doesn't group same cat_ids
  def self.top_fifty_cat_ids
    all_cat_ids = []
    self.all.order(checkins: :desc).limit(50).each do |c|
      unless all_cat_ids.include?(c.cat_id)
       all_cat_ids << c.cat_id
      end
    end
    all_cat_ids 
  end

  #returns hash of most popular categories by count {category_name => count}
  def self.most_popular_by_count(min_count)
    hash_categories_count = self.group(:cat_name).count.select {|name, count| count > min_count}
  end


end
