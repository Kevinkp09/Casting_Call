FactoryBot.define do
  factory :user do
    username { Faker::Name.username }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    mobile_no { Faker::PhoneNumber.mobile_no }
    role { User.roles.key.sample }
  end
end
