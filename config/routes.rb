Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      post "auth/google", to: "authentication#google_oauth2"
      resources :subbluedits, only: [ :show, :create ], param: :name do
        resources :posts, only: [ :create, :show ] do
          resources :comments, only: [ :create ]
          post :vote, to: "votes#create"
        end
      end
      resources :posts, only: [ :show ]
      resources :comments, only: [ :create ] do
        post :vote, to: "votes#create"
      end
    end
  end
end
