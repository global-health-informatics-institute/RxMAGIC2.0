class CreatePmapInventories < ActiveRecord::Migration[6.0]
  def change
    create_table :pmap_inventories, :primary_key => :pmap_inventory_id do |t|
      t.string :rxaui
      t.integer :patient_id
      t.string :pmap_identifier
      t.integer :manufacturer
      t.string :lot_number
      t.date :expiration_date
      t.date :date_received
      t.integer :received_quantity, :default => 0
      t.integer :current_quantity, :default => 0
      t.date :reorder_date
      t.boolean :voided, :default => false
      t.string :void_reason

      t.timestamps
    end
  end
end
