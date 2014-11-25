class AddImageUrlToHoods < ActiveRecord::Migration
  def change
    add_column :hoods, :image_url, :string
  end
end
