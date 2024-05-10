FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    username { Faker::Internet.username }
    mobile_no { '1234567890' }
    role { User.roles.keys.sample }
    approval_status { rand(0..1) }
    skin_color { 'fair' }
    current_location { Faker::Address.full_address }
    birth_date { Faker::Date.birthday }
    height { rand(120.0..200.0).round(2) }
    weight { rand(40.0..150.0).round(2) }
    posts_count { Faker::Number }
    gender { "Male" }
    category { 'Category' }
  end
end
