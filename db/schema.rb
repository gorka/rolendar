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

ActiveRecord::Schema[7.0].define(version: 2023_09_01_223639) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaign_sessions", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.string "title"
    t.datetime "datetime", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_sessions_on_campaign_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "campaign_sessions_count", default: 0, null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "user_id"
    t.bigint "campaign_id", null: false
    t.string "email", null: false
    t.string "token", null: false
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_invitations_on_campaign_id"
    t.index ["owner_id"], name: "index_invitations_on_owner_id"
    t.index ["token"], name: "unique_token", unique: true
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "campaign_id", null: false
    t.boolean "owner", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_memberships_on_campaign_id"
    t.index ["user_id", "campaign_id"], name: "index_memberships_on_user_id_and_campaign_id", unique: true
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "omniauth_developer_uid"
    t.string "discord_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "campaign_sessions", "campaigns"
  add_foreign_key "invitations", "campaigns"
  add_foreign_key "invitations", "users"
  add_foreign_key "invitations", "users", column: "owner_id"
  add_foreign_key "memberships", "campaigns"
  add_foreign_key "memberships", "users"
end
