class AddResolutionActionAndDateToNews < ActiveRecord::Migration[6.0]
  def change
    change_table :news do |o|
      o.column :resolution, :string
      o.column :date_resolved, :date
    end
  end
  def self.down
  end
end
