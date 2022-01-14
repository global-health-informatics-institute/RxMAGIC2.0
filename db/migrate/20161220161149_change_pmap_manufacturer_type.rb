class ChangePmapManufacturerType < ActiveRecord::Migration[6.0]
  change_column :pmap_inventories, :manufacturer, :integer
end
