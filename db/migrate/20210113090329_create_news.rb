class CreateNews < ActiveRecord::Migration[6.0]
  def change
    create_table :news, :primary_key => :news_id do |t|
      t.string :message
      t.string :news_type
      t.string :refers_to
      t.boolean :resolved, :default => false
      t.string :resolution
      t.datetime :date_resolved
      t.timestamps
    end
  end
end
