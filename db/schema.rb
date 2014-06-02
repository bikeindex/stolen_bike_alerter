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

ActiveRecord::Schema.define(version: 20140602211509) do

  create_table "bikes", force: true do |t|
    t.string   "bike_index_api_url"
    t.text     "bike_index_api_response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tweets", force: true do |t|
    t.integer  "twitter_account_id"
    t.integer  "twitter_tweet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bike_id"
  end

  add_index "tweets", ["twitter_account_id"], name: "index_tweets_on_twitter_account_id"

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
    t.boolean  "default",         default: false
  end

  add_index "twitter_accounts", ["latitude", "longitude"], name: "index_twitter_accounts_on_latitude_and_longitude"

end
