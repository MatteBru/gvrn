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

ActiveRecord::Schema.define(version: 20171114202909) do

  create_table "districts", force: :cascade do |t|
    t.string "name"
    t.integer "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "representatives", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "image"
    t.date "date_of_birth"
    t.text "biography"
    t.string "party"
    t.date "start_date"
    t.string "leadership_role"
    t.string "twitter_account"
    t.string "facebook_account"
    t.string "youtube_account"
    t.string "url"
    t.string "contact_form"
    t.boolean "in_office"
    t.float "dw_nominate"
    t.string "next_election"
    t.integer "total_votes"
    t.integer "missed_votes"
    t.string "office"
    t.string "phone"
    t.string "votes_with_party_pct"
    t.string "gender"
    t.boolean "at_large"
    t.string "google_entity_id"
    t.string "wikipedia"
    t.integer "district_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "senators", force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "image"
    t.date "date_of_birth"
    t.text "biography"
    t.string "party"
    t.date "start_date"
    t.string "leadership_role"
    t.string "twitter_account"
    t.string "facebook_account"
    t.string "youtube_account"
    t.string "url"
    t.string "contact_form"
    t.boolean "in_office"
    t.float "dw_nominate"
    t.string "next_election"
    t.integer "total_votes"
    t.integer "missed_votes"
    t.string "office"
    t.string "phone"
    t.string "state_rank"
    t.float "votes_with_party_pct"
    t.string "gender"
    t.string "google_entity_id"
    t.string "wikipedia"
    t.integer "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
