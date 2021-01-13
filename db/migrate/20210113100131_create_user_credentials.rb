class CreateUserCredentials < ActiveRecord::Migration[6.0]
  def change
    create_table :user_credentials do |t|
      t.integer :user_id, null: false
      t.string :password_hash, null: false
      t.string :password_salt, null: false

      t.timestamps
    end
  end
end
