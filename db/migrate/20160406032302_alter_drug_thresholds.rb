class AlterDrugThresholds < ActiveRecord::Migration[6.0]
  def change
    change_table :drug_thresholds do |o|
      o.column :voided, :boolean, :default => false
    end
  end
end
