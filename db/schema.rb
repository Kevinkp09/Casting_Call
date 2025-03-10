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

ActiveRecord::Schema[7.1].define(version: 2024_06_14_113253) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.string "scopes"
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "packages", force: :cascade do |t|
    t.integer "name", default: 0
    t.string "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "posts_limit"
    t.integer "requests_limit"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "agency_id"
    t.integer "package_id"
    t.string "razorpay_order_id"
    t.string "razorpay_payment_id"
    t.string "status_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "performances", force: :cascade do |t|
    t.string "video_link"
    t.string "audition_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "age"
    t.string "location"
    t.text "description"
    t.integer "role"
    t.integer "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "agency_id"
    t.integer "audition_type", default: 0
    t.integer "skin_color", default: 0
    t.decimal "height", precision: 5, scale: 2
    t.decimal "weight", precision: 5, scale: 2
    t.date "date"
    t.time "time"
    t.string "project_type"
    t.string "google_link"
    t.string "language"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "post_id", null: false
    t.integer "apply_status", default: 0
    t.string "link"
    t.index ["post_id"], name: "index_requests_on_post_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "mobile_no"
    t.integer "role", default: 0
    t.string "gender"
    t.string "category"
    t.date "birth_date"
    t.string "current_location"
    t.string "otp"
    t.datetime "otp_generated_time"
    t.integer "approval_status", default: 0
    t.integer "package_id"
    t.integer "skin_color", default: 0
    t.decimal "height", precision: 5, scale: 2
    t.decimal "weight", precision: 5, scale: 2
    t.integer "posts_count", default: 0
    t.string "agency_name"
    t.integer "is_agency", default: 0
    t.string "country"
    t.string "state"
    t.string "city"
    t.string "language"
    t.boolean "otp_verified", default: false
    t.string "account_no"
    t.string "branch_name"
    t.string "pan_no"
    t.string "gst_no"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "works", force: :cascade do |t|
    t.string "project_name"
    t.string "artist_role"
    t.date "year"
    t.string "youtube_link"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "project_type"
    t.index ["user_id"], name: "index_works_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "requests", "posts"
  add_foreign_key "requests", "users"
end
