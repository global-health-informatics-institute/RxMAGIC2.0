class AddVoidedToManufacturer < ActiveRecord::Migration[6.0]
  def change
    change_table :manufacturers do |p|
      p.boolean :voided, after: :has_pmap, :default => false
    end
  end
end
