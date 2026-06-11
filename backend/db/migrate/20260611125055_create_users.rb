class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :clerk_user_id
      t.string :email
      t.integer :point_balance, default: 0, null: false

      t.timestamps
    end
  end
end
