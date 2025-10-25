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

ActiveRecord::Schema[8.0].define(version: 2025_10_25_102425) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "folders", force: :cascade do |t|
    t.string "name", null: false
    t.integer "parent_id"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notes_count", default: 0, null: false
    t.integer "children_count", default: 0, null: false
    t.index ["parent_id"], name: "index_folders_on_parent_id"
    t.index ["user_id", "name", "parent_id"], name: "index_folders_on_user_id_and_name_and_parent_id", unique: true
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.string "title", null: false
    t.text "content"
    t.integer "folder_id"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_notes_on_folder_id"
    t.index ["title"], name: "index_notes_on_title"
    t.index ["user_id", "created_at"], name: "index_notes_on_user_id_and_created_at"
    t.index ["user_id", "folder_id"], name: "index_notes_on_user_id_and_folder_id"
    t.index ["user_id", "title"], name: "index_notes_on_user_id_and_title"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "notes_tags", force: :cascade do |t|
    t.integer "note_id", null: false
    t.integer "tag_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id", "tag_id"], name: "index_notes_tags_on_note_id_and_tag_id", unique: true
    t.index ["note_id"], name: "index_notes_tags_on_note_id"
    t.index ["tag_id", "note_id"], name: "index_notes_tags_on_tag_id_and_note_id"
    t.index ["tag_id"], name: "index_notes_tags_on_tag_id"
    t.index ["user_id"], name: "index_notes_tags_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notes_count", default: 0, null: false
    t.index ["name"], name: "index_tags_on_name"
    t.index ["user_id", "name"], name: "index_tags_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "todos", force: :cascade do |t|
    t.text "description", null: false
    t.boolean "completed", default: false, null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "completed"], name: "index_todos_on_user_id_and_completed"
    t.index ["user_id", "created_at"], name: "index_todos_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_todos_on_user_id"
  end

  create_table "todos_tags", force: :cascade do |t|
    t.integer "todo_id", null: false
    t.integer "tag_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id", "todo_id"], name: "index_todos_tags_on_tag_id_and_todo_id"
    t.index ["tag_id"], name: "index_todos_tags_on_tag_id"
    t.index ["todo_id", "tag_id"], name: "index_todos_tags_on_todo_id_and_tag_id", unique: true
    t.index ["todo_id"], name: "index_todos_tags_on_todo_id"
    t.index ["user_id"], name: "index_todos_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notes_count", default: 0, null: false
    t.integer "todos_count", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "folders", "folders", column: "parent_id"
  add_foreign_key "folders", "users"
  add_foreign_key "notes", "folders"
  add_foreign_key "notes", "users"
  add_foreign_key "notes_tags", "notes"
  add_foreign_key "notes_tags", "tags"
  add_foreign_key "notes_tags", "users"
  add_foreign_key "tags", "users"
  add_foreign_key "todos", "users"
  add_foreign_key "todos_tags", "tags"
  add_foreign_key "todos_tags", "todos"
  add_foreign_key "todos_tags", "users"
end
