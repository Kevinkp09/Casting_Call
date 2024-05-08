FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { "Flimania" }
    redirect_uri { "" }
    scopes {""}
  end
end
