class CreateHl7Errors < ActiveRecord::Migration[6.0]
  def change
    create_table :hl7_errors do |t|
      t.integer :patient_id
      t.integer :provider_id
      t.datetime :date_prescribed
      t.integer :quantity
      t.string :directions
      t.string :drug_name
      t.string :code
      t.boolean :voided, :default => false
      t.timestamps null: false
    end
  end
end
