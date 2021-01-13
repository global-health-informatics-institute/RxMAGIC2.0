class CreateDispensations < ActiveRecord::Migration[6.0]
  def change
    create_table :dispensations, :primary_key => :dispensation_id do |t|
      t.integer :rx_id
      t.string :inventory_id, null: false
      t.integer :patient_id
      t.integer :quantity
      t.datetime :dispensation_date
      t.boolean :voided, :default => false
      t.timestamps
    end
  end
end
