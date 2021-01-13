class CreateManufacturers < ActiveRecord::Migration[6.0]
  def change
    create_table :manufacturers, :primary_key => :manufacturer_id do |t|
      t.string :name
      t.boolean :has_pmap, :default => false
      t.boolean :voided, :default => false
      t.timestamps
    end
  end
end
