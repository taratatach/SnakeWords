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

ActiveRecord::Schema.define(:version => 20130210154455) do

  create_table "games", :force => true do |t|
    t.integer  "size"
    t.string   "dictionary"
    t.boolean  "finished"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "firstWord",  :default => ""
    t.integer  "fwX",        :default => 0
    t.integer  "fwY",        :default => 0
    t.boolean  "pass",       :default => false
  end

  create_table "games_players", :force => true do |t|
    t.integer "game_id"
    t.integer "player_id"
  end

  create_table "played_words", :force => true do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.string   "letter"
    t.string   "word"
    t.integer  "x"
    t.integer  "y"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.integer  "totalScore"
    t.integer  "totalWins"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "players", ["name"], :name => "index_players_on_name", :unique => true

end
