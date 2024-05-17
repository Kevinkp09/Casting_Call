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
        put :reject_request
        get :view_requests, on: :collection
        get :show_approved_agencies, on: :collection
        get :show_registered_artist, on: :collection
        put :upgrade_basic, on: :collection
        put :upgrade_advance, on: :collection
        get :find_user
        get :filter_starter, on: :collection
        get :filter_basic, on: :collection
        get :filter_advance, on: :collection
        get :credential, on: :collection
        get :view_profile
        post :reset_password_code, on: :collection
        put :reset_password, on: :collection
        post :add_images, on: :collection
        get :show_images, on: :collection
      end
        resources :works, only: [:index, :update, :create, :destroy]
        resources :posts, only: [:create, :index, :update, :destroy, :show] do
          get :view_applied_artist, on: :collection
          get :show_posts, on: :collection
          get :show_requests
       end
       resources :requests, only: [:create, :index] do
          put :approve_artist, on: :member
          put :reject_artist, on: :member
          get :filter_shortlisted, on: :collection
       end
       resources :packages
       resources :payments do
         post :callback, on: :collection
       end
    end
  end
end
