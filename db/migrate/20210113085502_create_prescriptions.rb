class CreatePrescriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :prescriptions, :primary_key => :rx_id do |t|
      t.integer :patient_id
      t.string :rxaui
      t.datetime :date_prescribed
      t.integer :quantity
      t.integer :amount_dispensed, :default => 0
      t.string :directions
      t.integer :provider_id
      t.boolean :voided, :default => false

      t.timestamps
    end
  end
end
