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

ActiveRecord::Schema[8.1].define(version: 2026_07_22_030000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audience_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_audience_types_on_name", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "information"
    t.string "pen_name"
    t.boolean "primary", default: false, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_authors_on_user_id"
  end

  create_table "phase_resources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "phase_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "updated_at", null: false
    t.index ["phase_id", "resource_id"], name: "idx_phase_resource_unique", unique: true
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

  create_table "resource_audience_types", force: :cascade do |t|
    t.bigint "audience_type_id", null: false
    t.datetime "created_at", null: false
    t.bigint "resource_id", null: false
    t.datetime "updated_at", null: false
    t.index ["audience_type_id"], name: "index_resource_audience_types_on_audience_type_id"
    t.index ["resource_id", "audience_type_id"], name: "idx_resource_audience_unique", unique: true
    t.index ["resource_id"], name: "index_resource_audience_types_on_resource_id"
  end

  create_table "resources", force: :cascade do |t|
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_resources_on_author_id"
    t.index ["status"], name: "index_resources_on_status"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "user_requests", force: :cascade do |t|
    t.boolean "approved", default: false, null: false
    t.datetime "created_at", null: false
    t.bigint "created_user_id"
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.text "purpose"
    t.text "reason"
    t.text "rejection_reason"
    t.boolean "reviewed", default: false, null: false
    t.datetime "reviewed_at"
    t.bigint "reviewed_by_id"
    t.datetime "updated_at", null: false
    t.index ["created_user_id"], name: "index_user_requests_on_created_user_id"
    t.index ["email"], name: "index_user_requests_on_email"
    t.index ["email"], name: "index_user_requests_on_unreviewed_email", unique: true, where: "(reviewed = false)"
    t.index ["reviewed", "created_at"], name: "index_user_requests_on_reviewed_and_created_at"
    t.index ["reviewed_by_id"], name: "index_user_requests_on_reviewed_by_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "authors", "users"
  add_foreign_key "phase_resources", "phases"
  add_foreign_key "phase_resources", "resources"
  add_foreign_key "phases", "phases", column: "parent_id"
  add_foreign_key "resource_audience_types", "audience_types"
  add_foreign_key "resource_audience_types", "resources"
  add_foreign_key "resources", "authors"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_requests", "users", column: "created_user_id"
  add_foreign_key "user_requests", "users", column: "reviewed_by_id"
end
