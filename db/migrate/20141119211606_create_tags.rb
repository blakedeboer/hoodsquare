class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :tagger_id
      t.integer :taggee_id 
      
      t.timestamps
    end
  end
end
