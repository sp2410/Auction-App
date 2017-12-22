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

ActiveRecord::Schema.define(version: 20171204233838) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "auctions", force: :cascade do |t|
    t.float    "value"
    t.integer  "product_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "ends_at"
    t.integer  "proxybid",   default: 0
    t.integer  "winner_id"
    t.index ["product_id"], name: "index_auctions_on_product_id"
  end

  create_table "bids", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "auction_id"
    t.float    "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auction_id"], name: "index_bids_on_auction_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "bills", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "product_id"
    t.string   "payment_method_nonce"
    t.index ["product_id"], name: "index_bills_on_product_id"
  end

  create_table "counter_offers", force: :cascade do |t|
    t.integer  "value"
    t.integer  "winner_id"
    t.boolean  "accepted_status", default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "auction_id"
    t.integer  "owner_id"
    t.index ["auction_id"], name: "index_counter_offers_on_auction_id"
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_likes_on_product_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "image"
    t.string   "alias"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "product_id"
    t.index ["product_id"], name: "index_pictures_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "year"
    t.string   "miles"
    t.string   "transmission"
    t.string   "color"
    t.string   "cylinder"
    t.string   "fuel"
    t.string   "drive"
    t.string   "address"
    t.string   "newused"
    t.string   "vin"
    t.string   "stocknumber"
    t.string   "model"
    t.string   "trim"
    t.string   "enginedescription"
    t.string   "interiorcolor"
    t.string   "options"
    t.integer  "originaluser_id"
    t.string   "bluebook"
    t.string   "miles_bluebook"
    t.string   "runs_condition"
    t.string   "drives_condition"
    t.string   "tires_condition"
    t.string   "paint_condition"
    t.string   "windshield_condition"
    t.string   "interior_condition"
    t.string   "check_engine_light"
    t.string   "ABS_light"
    t.string   "Airbag_light"
    t.string   "check_type"
    t.boolean  "billed",                default: false
    t.string   "warranty"
    t.integer  "sellerselected_option", default: 0
    t.string   "imagefront"
    t.string   "imageback"
    t.string   "imageleft"
    t.string   "imageright"
    t.string   "frontinterior"
    t.string   "rearinterior"
    t.string   "stage",                 default: "never_auctioned"
    t.boolean  "reviewed",              default: false
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.boolean  "approved",   default: false
    t.integer  "user_id"
    t.string   "comment"
    t.integer  "rating"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "owner_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "transaction_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "bill_id"
    t.index ["bill_id"], name: "index_transactions_on_bill_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "time_zone"
    t.string   "dealer_Name",            default: "Doe"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "bond_Number"
    t.string   "dealer_Number"
    t.string   "reseller_Number"
    t.string   "primary_Phone"
    t.string   "mobile_Phone_Number"
    t.string   "mobile_Phone_Carrier"
    t.boolean  "receiveemail",           default: false
    t.string   "referredby"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
