# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_01_020828) do

  create_table "ate_foods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "day_id"
    t.bigint "food_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day_id"], name: "index_ate_foods_on_day_id"
    t.index ["food_id"], name: "index_ate_foods_on_food_id"
  end

  create_table "bodies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.decimal "weight", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "percentage", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "day_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day_id"], name: "index_bodies_on_day_id"
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "days", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.date "date", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_days_on_user_id"
  end

  create_table "dishes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.decimal "calory", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "protein", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "fat", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "carbonhydrate", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "day_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["day_id"], name: "index_dishes_on_day_id"
  end

  create_table "foods", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.integer "per", null: false
    t.string "unit", null: false
    t.decimal "calory", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "protein", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "fat", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "carbonhydrate", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_foods_on_category_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "activated", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "ate_foods", "days"
  add_foreign_key "ate_foods", "foods"
  add_foreign_key "bodies", "days"
  add_foreign_key "categories", "users"
  add_foreign_key "days", "users"
  add_foreign_key "dishes", "days"
  add_foreign_key "foods", "categories"
end
