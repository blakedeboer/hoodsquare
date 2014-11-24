class ChangeHoodIdInCategory < ActiveRecord::Migration
  
  def up
    change_column :categories, :cat_id, :string
  end

   def down
    change_column :categories, :cat_id, :integer
  end

end
