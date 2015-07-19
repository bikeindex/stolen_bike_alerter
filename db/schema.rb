# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150717171906) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bikes", force: true do |t|
    t.string   "bike_index_api_url"
    t.text     "bike_index_api_response"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "state"
    t.string   "neighborhood"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "bike_index_bike_id"
    t.string   "country"
  end

  create_table "retweets", force: true do |t|
    t.integer  "twitter_account_id"
    t.integer  "tweet_id"
    t.integer  "twitter_tweet_id",   limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bike_id"
  end

  create_table "tweets", force: true do |t|
    t.integer  "twitter_account_id"
    t.integer  "twitter_tweet_id",     limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bike_id"
    t.text     "tweet_string"
    t.text     "bike_index_post_hash"
  end

  add_index "tweets", ["twitter_account_id"], name: "index_tweets_on_twitter_account_id", using: :btree

  create_table "twitter_accounts", force: true do |t|
    t.string   "screen_name"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "consumer_key"
    t.string   "consumer_secret"
    t.string   "user_token"
    t.string   "user_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.boolean  "is_national",          default: false, null: false
    t.text     "twitter_account_info"
    t.string   "language"
    t.boolean  "is_active",            default: false, null: false
    t.string   "append_block"
    t.boolean  "default",              default: false, null: false
    t.string   "country"
    t.string   "city"
    t.string   "state"
    t.string   "neighborhood"
  end

  add_index "twitter_accounts", ["latitude", "longitude"], name: "index_twitter_accounts_on_latitude_and_longitude", using: :btree

  create_table "users", force: true do |t|
    t.string   "twitter_uid",         default: "", null: false
    t.string   "encrypted_password",  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.json     "twitter_info"
    t.integer  "twitter_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["twitter_account_id"], name: "index_users_on_twitter_account_id", unique: true, using: :btree
  add_index "users", ["twitter_uid"], name: "index_users_on_twitter_uid", unique: true, using: :btree

end
