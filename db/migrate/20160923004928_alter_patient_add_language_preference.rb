class AlterPatientAddLanguagePreference < ActiveRecord::Migration[6.0]
  def change
    change_table :patients do |p|
      p.string :language,:default => "ENG", after: :birthdate
    end
  end
end
