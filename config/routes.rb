Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :books, only: %i[index show] do
    resources :ownerships, only: %i[new create]
  end

  resources :ownerships, only: %i[index show new create destroy] do
    resources :rentals, only: %i[new create]
  end

  resources :rentals, only: [:index, :update]

  namespace :owner do
    resources :rentals, only: [:index, :update]
  end

  resources :lists do
    resources :list_items, only: %i[create destroy]
  end

  post 'wishlist_list_items', to: 'list_items#create', as: 'wishlist_list_items'

  # Search route
  get '/search', to: 'search#index', as: 'search'

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
