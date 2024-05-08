FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    username { Faker::Internet.username }
    mobile_no { '1234567890' }
    role { User.roles.keys.sample }
  end
end
