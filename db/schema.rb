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

ActiveRecord::Schema[7.0].define(version: 2023_07_07_160432) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guests", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.text "phone_numbers", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_guests_on_email", unique: true
  end

  create_table "payload_formats", force: :cascade do |t|
    t.json "schema"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.string "code"
    t.date "start_date"
    t.date "end_date"
    t.integer "nights_count", default: 0
    t.integer "total_guests_count", default: 0
    t.integer "adults_count", default: 0
    t.integer "children_count", default: 0
    t.integer "infants_count", default: 0
    t.string "status"
    t.string "host_currency"
    t.integer "payout_price_cents", default: 0
    t.integer "security_price_cents", default: 0
    t.integer "total_price_cents", default: 0
    t.bigint "guest_id", null: false
    t.bigint "payload_format_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_reservations_on_code", unique: true
    t.index ["guest_id"], name: "index_reservations_on_guest_id"
    t.index ["payload_format_id"], name: "index_reservations_on_payload_format_id"
  end

  add_foreign_key "reservations", "guests"
  add_foreign_key "reservations", "payload_formats"
end
