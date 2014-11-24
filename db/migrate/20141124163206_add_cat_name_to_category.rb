class AddCatNameToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :cat_name, :string
  end
end
