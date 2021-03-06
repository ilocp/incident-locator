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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130613095643) do

  create_table "assignments", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "assignments", ["user_id", "role_id"], :name => "index_assignments_on_user_id_and_role_id"

  create_table "grants", :force => true do |t|
    t.integer  "right_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "grants", ["right_id", "role_id"], :name => "index_grants_on_right_id_and_role_id"

  create_table "incidents", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.float    "radius"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "reports_count", :default => 0
    t.float    "avg_lat"
    t.float    "avg_lng"
    t.float    "std_dev"
  end

  add_index "incidents", ["latitude", "longitude"], :name => "index_incidents_on_latitude_and_longitude"

  create_table "reports", :force => true do |t|
    t.integer  "user_id"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "heading"
    t.integer  "incident_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "reports", ["latitude", "longitude"], :name => "index_reports_on_latitude_and_longitude"
  add_index "reports", ["user_id"], :name => "index_reports_on_user_id"

  create_table "rights", :force => true do |t|
    t.string   "resource"
    t.string   "operation"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
