class AddImageUrlToHoods < ActiveRecord::Migration
  def change
    add_column :hoods, :img_url, :string
  end
end
