class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :hood_id
      t.integer :cat_id
      t.integer :checkins

      t.timestamps
    end
  end
end
