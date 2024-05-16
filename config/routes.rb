Rails.application.routes.draw do
  get 'list_items/new'
  get 'list_items/create'
  get 'list_items/destroy'
  get 'lists/index'
  get 'lists/show'
  get 'lists/new'
  get 'lists/create'
  get 'lists/destroy'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # index (Moritz), show (Andrew/Yoana) (new/create - booking request form will be here as well), bookings '/rentals (Vincent/team)
  resources :books, only: %i[index show]
  resources :ownerships, only: %i[index show new create] do
    resources :rentals, only: %i[new create]
  end
  resources :rentals, only: [:index]
  namespace :owner do
    resources :rentals, only: [:index]
  end
  resources :lists do
    resources :list_items, only: %i[create destroy]
  end

  post 'wishlist_list_items', to: 'list_items#create', as: 'wishlist_list_items'
  # Defines the root path route ("/")
  # root "posts#index"

  # Search route
  get '/search', to: 'search#index', as: 'search'
end
