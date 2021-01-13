class CreateGeneralInventories < ActiveRecord::Migration[6.0]
  def change
    create_table :general_inventories, :primary_key => :gn_inventory_id do |t|
      t.string :rxaui
      t.string :gn_identifier
      t.string :lot_number
      t.integer :manufacturer_id
      t.date :expiration_date
      t.date :date_received
      t.integer :received_quantity, :default => 0
      t.integer :current_quantity, :default => 0
      t.boolean :voided, :default => false
      t.string :void_reason
      t.integer :voided_bys
      t.timestamps
    end
  end
end
