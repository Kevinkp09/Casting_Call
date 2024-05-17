FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    age { Faker::Number }
    location { Faker::Address.full_address }
    description { Faker::Lorem.paragraph }
    role { Post.roles.keys.sample }
    category { Post.categories.keys.sample }
    audition_type { Post.audition_types.keys.sample }
    skin_color { Post.skin_colors.keys.sample }
    height { rand(120.0..200.0).round(2) }
    weight { rand(40.0..150.0).round(2) }
    date { Faker::Date.forward(days: 30) }
    time { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
  end
end
