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

ActiveRecord::Schema[7.2].define(version: 2025_03_08_121319) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_cards", force: :cascade do |t|
    t.text "explanation"
    t.text "answer"
    t.text "question"
    t.integer "level"
    t.datetime "last_recal"
    t.bigint "deck_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "next_recall"
    t.index ["deck_id"], name: "index_active_cards_on_deck_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "topic_id"
  end

  create_table "test_cards", force: :cascade do |t|
    t.text "explanation"
    t.text "answer"
    t.text "user_answer"
    t.text "question"
    t.string "state"
    t.boolean "answered_correctly"
    t.bigint "test_id"
    t.bigint "active_card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_card_id"], name: "index_test_cards_on_active_card_id"
    t.index ["test_id"], name: "index_test_cards_on_test_id"
  end

  create_table "tests", force: :cascade do |t|
    t.string "state"
    t.datetime "finished_at"
    t.integer "cards_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "topic_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_cards", "decks"
  add_foreign_key "test_cards", "active_cards"
  add_foreign_key "test_cards", "tests"
end
