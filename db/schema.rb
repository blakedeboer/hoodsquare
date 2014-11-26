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

ActiveRecord::Schema.define(version: 20141125161904) do

  create_table "categories", force: true do |t|
    t.integer  "hood_id"
    t.integer  "cat_id"
    t.integer  "checkins"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hoods", force: true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.string   "latlng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "img_url"
  end

  create_table "tags", force: true do |t|
    t.integer  "tagger_id"
    t.integer  "taggee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
