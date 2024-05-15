Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # index (Moritz), show (Andrew/Yoana) (new/create - booking request form will be here as well), bookings '/rentals (Vincent/team)
  resources :books, only: %i[index show]
  resources :ownerships, only: %i[index show] do
    resources :rentals, only: %i[new create]
  end
  resources :rentals, only: [:index]
  namespace :owner do
    resources :rentals, only: [:index]
  end
  # Use devise current_user

  # Defines the root path route ("/")
  # root "posts#index"

  # Search route
  get '/search', to: 'search#index', as: 'search'
end
