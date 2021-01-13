class CreateProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :providers, :primary_key => :provider_id do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
