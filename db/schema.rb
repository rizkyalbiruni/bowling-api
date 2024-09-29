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

ActiveRecord::Schema[7.1].define(version: 2024_09_29_135841) do
  create_table "frames", force: :cascade do |t|
    t.integer "frame_nth"
    t.boolean "is_strike"
    t.boolean "is_spare"
    t.integer "total_score"
    t.integer "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_frames_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "current_frame"
    t.integer "total_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "throws", force: :cascade do |t|
    t.integer "throw_nth"
    t.integer "score"
    t.integer "frame_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["frame_id"], name: "index_throws_on_frame_id"
  end

  add_foreign_key "frames", "games"
  add_foreign_key "throws", "frames"
end
