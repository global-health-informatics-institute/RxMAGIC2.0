class ChangeNewsTypeColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :news, :type, :news_type
  end
end
