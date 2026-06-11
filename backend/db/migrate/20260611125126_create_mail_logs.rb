class CreateMailLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :mail_logs do |t|
      t.references :purchase, null: true, foreign_key: true
      t.string :mail_type
      t.string :recipient_email
      t.string :subject
      t.string :status
      t.datetime :sent_at

      t.timestamps
    end
  end
end
