class CreatePointLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :point_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :log_type
      t.integer :point
      t.text :description

      t.timestamps
    end

    add_check_constraint :point_logs, "point <> 0", name: "point_not_zero"
  end
end
