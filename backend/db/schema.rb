# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_11_125126) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "mail_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "mail_type"
    t.bigint "purchase_id"
    t.string "recipient_email"
    t.datetime "sent_at"
    t.string "status"
    t.string "subject"
    t.datetime "updated_at", null: false
    t.index ["purchase_id"], name: "index_mail_logs_on_purchase_id"
  end

  create_table "point_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "log_type"
    t.integer "point"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_point_logs_on_user_id"
    t.check_constraint "point <> 0", name: "point_not_zero"
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.text "file_url"
    t.text "image_url"
    t.boolean "is_active"
    t.integer "point_price"
    t.text "thumbnail_url"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "purchases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "point_used"
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["product_id"], name: "index_purchases_on_product_id"
    t.index ["user_id", "product_id"], name: "index_purchases_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "clerk_user_id"
    t.datetime "created_at", null: false
    t.string "email"
    t.integer "point_balance", default: 0, null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "mail_logs", "purchases"
  add_foreign_key "point_logs", "users"
  add_foreign_key "purchases", "products"
  add_foreign_key "purchases", "users"
end
