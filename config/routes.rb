Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  devise_for :users,  contollers: {
    omniauth_callbacks: 'api/v1/omniauth_callbacks'
}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create] do
        get :show_details, on: :collection
        get :show_work, on: :collection
        post :login, on: :collection
        post :add_details, on: :collection
        post :work_details, on: :collection
        post :verify_otp, on: :collection
        post :view_requests, on: :collection
      end
    end
  end
end
