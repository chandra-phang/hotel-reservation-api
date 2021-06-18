# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_16_155246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guests", force: :cascade do |t|
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone_number", null: false
    t.string "external_id", null: false
    t.integer "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "total_paid_amount", null: false
    t.integer "security_price", null: false
    t.integer "total_price", null: false
    t.string "currency", null: false
    t.integer "creator_id", null: false
    t.integer "guest_id", null: false
    t.integer "reservation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.string "status", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.integer "nights", null: false
    t.integer "total_guest", null: false
    t.integer "adult_guest", null: false
    t.integer "children_guest", null: false
    t.integer "infant_guest", null: false
    t.integer "creator_id", null: false
    t.integer "guest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "state", default: "active"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "guests", "users", column: "creator_id"
  add_foreign_key "invoices", "guests"
  add_foreign_key "invoices", "reservations"
  add_foreign_key "invoices", "users", column: "creator_id"
  add_foreign_key "reservations", "guests"
  add_foreign_key "reservations", "users", column: "creator_id"
end
