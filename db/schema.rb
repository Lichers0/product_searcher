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

ActiveRecord::Schema.define(version: 2021_05_10_095522) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "pricelist_records", force: :cascade do |t|
    t.bigint "task_id", null: false
    t.string "upc"
    t.decimal "cost", precision: 8, scale: 2
    t.boolean "processed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["task_id"], name: "index_pricelist_records_on_task_id"
  end

  create_table "profit_pairs", force: :cascade do |t|
    t.string "asin"
    t.decimal "income", precision: 8, scale: 2
    t.decimal "weight", precision: 8, scale: 2
    t.integer "quantity_unit"
    t.integer "bsr"
    t.integer "total_offers"
    t.integer "fba_offers"
    t.decimal "buybox_price", precision: 8, scale: 2
    t.string "title"
    t.string "brand"
    t.bigint "pricelist_record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pricelist_record_id"], name: "index_profit_pairs_on_pricelist_record_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "email", null: false
    t.string "seller_id", null: false
    t.string "mws_auth_token", null: false
    t.decimal "ship_to_fba", precision: 8, scale: 2, null: false
    t.decimal "services_cost", precision: 8, scale: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "pricelist_records", "tasks"
  add_foreign_key "profit_pairs", "pricelist_records"
end
