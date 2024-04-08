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
        post :login, on: :collection
        put :add_details, on: :collection
        post :verify_otp, on: :collection
        put :approve_request, on: :collection
        put :reject_request, on: :collection
        get :view_requests, on: :collection
        get :show_approved_agencies, on: :collection
        get :show_registered_artist, on: :collection
      end
        resources :works, only: [:index, :update, :create, :destroy]
        resources :posts, only: [:create, :index, :update, :destroy, :show] do
          get :view_applied_artist, on: :collection
          get :show_posts, on: :collection
       end
       resources :requests, only: [:index, :create] do
          put :approve_artist, on: :member
          put :reject_artist, on: :member
       end
    end
  end
end
