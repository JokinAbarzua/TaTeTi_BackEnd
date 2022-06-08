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

ActiveRecord::Schema[7.0].define(version: 2022_05_11_192521) do
  create_table "boards", force: :cascade do |t|
    t.string "name"
    t.string "winner"
    t.integer "state", default: 0
    t.string "table", default: "n,n,n,n,n,n,n,n,n"
    t.string "nextPlayer"
    t.integer "player1_id"
    t.integer "player2_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player1_id"], name: "index_boards_on_player1_id"
    t.index ["player2_id"], name: "index_boards_on_player2_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "full_name"
    t.string "alias"
    t.string "password"
    t.integer "victories"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
