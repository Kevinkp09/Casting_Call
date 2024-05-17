FactoryBot.define do
  factory :package do
    name { "starter" }
    posts_limit { 3 }
    requests_limit { 5 }
  end
end
