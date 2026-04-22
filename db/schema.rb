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

ActiveRecord::Schema[8.1].define(version: 2026_04_22_202228) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "phase_resources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "phase_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "updated_at", null: false
    t.index ["phase_id"], name: "index_phase_resources_on_phase_id"
    t.index ["resource_id"], name: "index_phase_resources_on_resource_id"
  end

  create_table "phases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.bigint "parent_id"
    t.integer "position"
    t.text "summary"
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_phases_on_parent_id"
  end

  create_table "resources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "phase_resources", "phases"
  add_foreign_key "phase_resources", "resources"
  add_foreign_key "phases", "phases", column: "parent_id"
end
