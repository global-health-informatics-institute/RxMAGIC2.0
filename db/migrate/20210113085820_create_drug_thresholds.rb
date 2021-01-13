class CreateDrugThresholds < ActiveRecord::Migration[6.0]
  def change
    create_table :drug_thresholds, :primary_key => :threshold_id do |t|
      t.string :rxaui
      t.string :rxcui, null: false
      t.integer :threshold
      t.boolean :voided, :default => false
      t.timestamps
    end
  end
end
