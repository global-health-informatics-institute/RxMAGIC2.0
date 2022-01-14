# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "csv"

puts("Load manufacturers")
CSV.foreach("#{Rails.root}/db/manufacturers.csv", :headers => :first_row, :col_sep => ";") do |row|
    company = Manufacturer.where(name: row[0].strip).first_or_initialize
    company.has_pmap = row[1].strip rescue false
    company.save
end
