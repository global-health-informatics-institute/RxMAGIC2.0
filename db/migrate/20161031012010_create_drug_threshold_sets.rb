class CreateDrugThresholdSets < ActiveRecord::Migration[6.0]
  def change
    create_table :drug_threshold_sets, :primary_key => :drug_set_id do |t|
      t.integer :threshold_id
      t.string :rxaui
      t.boolean :voided, :default => false
      t.timestamps null: false
    end
  end
end
