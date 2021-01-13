class CreatePatients < ActiveRecord::Migration[6.0]
  def change
    create_table :patients, :primary_key => :patient_id do |t|
      t.string :mrn
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date :birthdate
      t.string :language, :default => "ENG"
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.boolean :voided, :default => false
      t.timestamps
    end
  end
end
