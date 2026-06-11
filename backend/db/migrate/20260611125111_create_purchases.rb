class CreatePurchases < ActiveRecord::Migration[8.1]
  def change
    create_table :purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :point_used

      t.timestamps
    end

    add_index :purchases, [:user_id, :product_id], unique: true
  end
end
