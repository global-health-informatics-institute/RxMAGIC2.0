class CreateNdcCodeMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :ndc_code_matches do |t|
      t.string :missing_code
      t.string :rxaui
      t.string :name

      t.timestamps
    end
  end
end
