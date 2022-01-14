class CreateNews < ActiveRecord::Migration[6.0]
  def change
    create_table :news, :primary_key => :news_id do |t|
      t.string :message
      t.string :type
      t.boolean :resolved, :default => false
      t.timestamps null: false
    end
  end
end
