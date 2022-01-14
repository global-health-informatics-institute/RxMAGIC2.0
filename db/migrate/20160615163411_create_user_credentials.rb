class CreateUserCredentials < ActiveRecord::Migration[6.0]
  def change
    create_table :user_credentials do |t|
      t.string :password_hash
      t.string :password_salt
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
