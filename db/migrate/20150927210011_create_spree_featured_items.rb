class CreateSpreeFeaturedItems < ActiveRecord::Migration
  def change
    create_table :spree_featured_items do |t|
      t.string :title, null: false
      t.string :body, null: false
      t.string :type, null: false
      t.attachment :image, null: false
      t.string :url, null: false
      t.boolean :active, null: false, default: true, index: true
      t.integer :position, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
