FactoryBot.define do
  factory :work do
    project_name { Faker::Lorem.words(number: 3).join(" ") }
    artist_role { Faker::Lorem.word }
    year { Faker::Date.backward }
    youtube_link { Faker::Internet.url(host: 'youtube.com') } 
  end
end
