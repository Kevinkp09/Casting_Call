# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
if !Doorkeeper::Application.any?
  Doorkeeper::Application.create!(name: "Filmania", redirect_uri: "", scopes: "")
end

if !User.any?
  User.create(username: "kevin", email: "kevinpatel907.kp@gmail.com", password: "123456", role: "admin",mobile_no: 1234567890)
end
