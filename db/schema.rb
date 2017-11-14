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

ActiveRecord::Schema.define(version: 20171114101638) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customer_comparisons", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "customer2_id"
    t.string   "customer2_name"
    t.float    "sim_pearson"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.integer  "position"
    t.integer  "prev_position"
    t.string   "name_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.float    "sales_last_year"
    t.float    "sales_ytd"
  end

  create_table "customers_products", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "customer_id"
    t.float    "total_sales"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "invoice_id"
    t.date     "invoice_date"
    t.integer  "quantity"
    t.float    "unit_price"
    t.float    "discount"
    t.float    "total_price"
    t.boolean  "promo"
    t.integer  "product_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "product_number"
  end

  create_table "products", force: :cascade do |t|
    t.string   "number"
    t.integer  "position"
    t.integer  "prev_position"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.date     "last_sold"
    t.float    "sales_last_year"
    t.float    "sales_ytd"
  end

  create_table "recommended_items", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "product_id"
    t.float    "projected_sales"
    t.string   "product_number"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "sales_numbers", force: :cascade do |t|
    t.integer  "month"
    t.integer  "year"
    t.float    "sales"
    t.integer  "product_id"
    t.integer  "customer_id"
    t.boolean  "rep_number",  default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.float    "sales_ytd"
    t.float    "prev_sales_ytd"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
