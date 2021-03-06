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

ActiveRecord::Schema.define(version: 20131222182611) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invites", force: true do |t|
    t.integer  "user_id"
    t.integer  "invitee_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["invitee_id"], name: "index_invites_on_invitee_id", using: :btree
  add_index "invites", ["user_id"], name: "index_invites_on_user_id", using: :btree

  create_table "reactions", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved",   default: false
  end

  add_index "reactions", ["approved", "id"], name: "index_reactions_on_approved_and_id", using: :btree
  add_index "reactions", ["user_id"], name: "index_reactions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "can_post",        default: true
    t.boolean  "trusted",         default: false
    t.boolean  "moderator",       default: false
  end

end
