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

ActiveRecord::Schema.define(version: 2016_09_23_004928) do

  create_table "RXNATOMARCHIVE", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "RXAUI", limit: 8, null: false
    t.string "AUI", limit: 10
    t.string "STR", limit: 4000, null: false
    t.string "ARCHIVE_TIMESTAMP", limit: 280, null: false
    t.string "CREATED_TIMESTAMP", limit: 280, null: false
    t.string "UPDATED_TIMESTAMP", limit: 280, null: false
    t.string "CODE", limit: 50
    t.string "IS_BRAND", limit: 1
    t.string "LAT", limit: 3
    t.string "LAST_RELEASED", limit: 30
    t.string "SAUI", limit: 50
    t.string "VSAB", limit: 40
    t.string "RXCUI", limit: 8
    t.string "SAB", limit: 20
    t.string "TTY", limit: 20
    t.string "MERGED_TO_RXCUI", limit: 8
  end

  create_table "RXNCONSO", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "RXCUI", limit: 8, null: false
    t.string "LAT", limit: 3, default: "ENG", null: false
    t.string "TS", limit: 1
    t.string "LUI", limit: 8
    t.string "STT", limit: 3
    t.string "SUI", limit: 8
    t.string "ISPREF", limit: 1
    t.string "RXAUI", limit: 8, null: false
    t.string "SAUI", limit: 50
    t.string "SCUI", limit: 50
    t.string "SDUI", limit: 50
    t.string "SAB", limit: 20, null: false
    t.string "TTY", limit: 20, null: false
    t.string "CODE", limit: 50, null: false
    t.string "STR", limit: 3000, null: false
    t.string "SRL", limit: 10
    t.string "SUPPRESS", limit: 1
    t.string "CVF", limit: 50
    t.index ["RXAUI"], name: "X_RXNCONSO_RXAUI"
  end

  create_table "RXNCUI", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "cui1", limit: 8
    t.string "ver_start", limit: 40
    t.string "ver_end", limit: 40
    t.string "cardinality", limit: 8
    t.string "cui2", limit: 8
  end

  create_table "RXNCUICHANGES", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "RXAUI", limit: 8
    t.string "CODE", limit: 50
    t.string "SAB", limit: 20
    t.string "TTY", limit: 20
    t.string "STR", limit: 3000
    t.string "OLD_RXCUI", limit: 8, null: false
    t.string "NEW_RXCUI", limit: 8, null: false
  end

  create_table "RXNDOC", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "DOCKEY", limit: 50, null: false
    t.string "VALUE", limit: 1000
    t.string "TYPE", limit: 50, null: false
    t.string "EXPL", limit: 1000
  end

  create_table "RXNREL", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "RXCUI1", limit: 8
    t.string "RXAUI1", limit: 8
    t.string "STYPE1", limit: 50
    t.string "REL", limit: 4
    t.string "RXCUI2", limit: 8
    t.string "RXAUI2", limit: 8
    t.string "STYPE2", limit: 50
    t.string "RELA", limit: 100
    t.string "RUI", limit: 10
    t.string "SRUI", limit: 50
    t.string "SAB", limit: 20, null: false
    t.string "SL", limit: 1000
    t.string "DIR", limit: 1
    t.string "RG", limit: 10
    t.string "SUPPRESS", limit: 1
    t.string "CVF", limit: 50
  end

  create_table "RXNSAB", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "VCUI", limit: 8
    t.string "RCUI", limit: 8
    t.string "VSAB", limit: 40
    t.string "RSAB", limit: 20, null: false
    t.string "SON", limit: 3000
    t.string "SF", limit: 20
    t.string "SVER", limit: 20
    t.string "VSTART", limit: 10
    t.string "VEND", limit: 10
    t.string "IMETA", limit: 10
    t.string "RMETA", limit: 10
    t.string "SLC", limit: 1000
    t.string "SCC", limit: 1000
    t.integer "SRL"
    t.integer "TFR"
    t.integer "CFR"
    t.string "CXTY", limit: 50
    t.string "TTYL", limit: 300
    t.string "ATNL", limit: 1000
    t.string "LAT", limit: 3
    t.string "CENC", limit: 20
    t.string "CURVER", limit: 1
    t.string "SABIN", limit: 1
    t.string "SSN", limit: 3000
    t.string "SCIT", limit: 4000
  end

  create_table "RXNSAT", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "RXCUI", limit: 8
    t.string "LUI", limit: 8
    t.string "SUI", limit: 8
    t.string "RXAUI", limit: 8
    t.string "STYPE", limit: 50
    t.string "CODE", limit: 50
    t.string "ATUI", limit: 11
    t.string "SATUI", limit: 50
    t.string "ATN", limit: 1000, null: false
    t.string "SAB", limit: 20, null: false
    t.string "ATV", limit: 4000
    t.string "SUPPRESS", limit: 1
    t.string "CVF", limit: 50
  end

  create_table "RXNSTY", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "RXCUI", limit: 8, null: false
    t.string "TUI", limit: 4
    t.string "STN", limit: 100
    t.string "STY", limit: 50
    t.string "ATUI", limit: 11
    t.string "CVF", limit: 50
  end

  create_table "dispensations", primary_key: "dispensation_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "rx_id"
    t.string "inventory_id"
    t.integer "patient_id"
    t.integer "quantity"
    t.datetime "dispensation_date"
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drug_thresholds", primary_key: "threshold_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "rxaui"
    t.integer "threshold"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "voided", default: false
    t.string "rxcui", null: false
  end

  create_table "general_inventories", primary_key: "gn_inventory_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "rxaui"
    t.string "gn_identifier"
    t.string "lot_number"
    t.date "expiration_date"
    t.date "date_received"
    t.integer "received_quantity", default: 0
    t.integer "current_quantity", default: 0
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "void_reason"
    t.integer "voided_by"
  end

  create_table "news", primary_key: "news_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "message"
    t.string "news_type"
    t.boolean "resolved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "refers_to"
    t.string "resolution"
    t.date "date_resolved"
  end

  create_table "patients", primary_key: "patient_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "epic_id"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.date "birthdate"
    t.string "language", default: "ENG"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pmap_inventories", primary_key: "pap_inventory_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "rxaui"
    t.string "lot_number"
    t.string "pap_identifier"
    t.integer "patient_id"
    t.date "expiration_date"
    t.integer "received_quantity", default: 0
    t.integer "current_quantity", default: 0
    t.date "reorder_date"
    t.date "date_received"
    t.boolean "voided", default: false
    t.string "void_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "manufacturer"
  end

  create_table "prescriptions", primary_key: "rx_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "patient_id"
    t.string "rxaui"
    t.datetime "date_prescribed"
    t.integer "quantity"
    t.string "directions"
    t.integer "provider_id"
    t.boolean "voided", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_dispensed", default: 0
  end

  create_table "providers", primary_key: "provider_id", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_credentials", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "password_hash"
    t.string "password_salt"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "username"
    t.string "user_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
