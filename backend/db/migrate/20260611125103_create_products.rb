class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.integer :point_price
      t.text :file_url
      t.text :image_url
      t.text :thumbnail_url
      t.boolean :is_active

      t.timestamps
    end
  end
end
