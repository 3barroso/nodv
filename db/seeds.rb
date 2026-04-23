# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Create Audience Type objects
puts "~~~~~~ Creating Audience Type Objects ~~~~~~"
['Family', 'Friend', 'Self', 'Case Manager'].each do |type|
  AudienceType.find_or_create_by!(name: type)
end

# Admin User
puts "~~~~~~ Creating Admin user ~~~~~~"
User.create!(email_address: "admin@nodv.org", admin: true, password: "hello", password_confirmation: "hello")

puts "~~~~~~ Creating Author user ~~~~~~"
User.create!(email_address: "author@nodv.org", password: "world", password_confirmation: "world")
