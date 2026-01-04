# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Test users for login testing
User.find_or_create_by!(email_address: "test@test.com") do |user|
  user.password = "password123"
end

User.find_or_create_by!(email_address: "admin@test.com") do |user|
  user.password = "admin123"
end

User.find_or_create_by!(email_address: "user@test.com") do |user|
  user.password = "test123"
end
