class NewcomerRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :newcomer_records do |t|
      t.integer :item_id
      t.string :title
      t.integer :points
      t.string :author
      t.integer :total_comments
      t.integer :item_created_at
      t.float :growth_rate
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
