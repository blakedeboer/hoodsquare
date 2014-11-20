class CreateHoods < ActiveRecord::Migration
  def change
    create_table :hoods do |t|
      t.string :name
      t.integer :city_id
      t.string :latlng
      
      t.timestamps
    end
  end
end
