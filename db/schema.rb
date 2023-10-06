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

ActiveRecord::Schema[7.0].define(version: 2023_10_05_144352) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "match_result", ["not_played_yet", "team_a_won", "team_b_won"]
  create_enum "match_stage", ["division_a", "division_b", "playoff"]
  create_enum "tournament_stage", ["registration", "divisions", "playoffs", "completed"]

  create_table "matches", force: :cascade do |t|
    t.integer "playoff_number", default: 0, null: false
    t.enum "stage", null: false, enum_type: "match_stage"
    t.enum "result", default: "not_played_yet", null: false, enum_type: "match_result"
    t.bigint "tournament_id"
    t.bigint "team_a_id"
    t.bigint "team_b_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_a_id"], name: "index_matches_on_team_a_id"
    t.index ["team_b_id"], name: "index_matches_on_team_b_id"
    t.index ["tournament_id"], name: "index_matches_on_tournament_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.bigint "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_teams_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.enum "stage", default: "registration", null: false, enum_type: "tournament_stage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "matches", "teams", column: "team_a_id"
  add_foreign_key "matches", "teams", column: "team_b_id"
  add_foreign_key "matches", "tournaments"
  add_foreign_key "teams", "tournaments"
end
