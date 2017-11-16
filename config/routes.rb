Rails.application.routes.draw do
  resources :representatives, only: [:index, :show]
  resources :senators, only: [:index, :show]
  root to: "static#welcome"
  resources :sessions, only: [:create, :destroy]
  get "/login", to: "sessions#login", as: "login"
  get "/signup", to: "users#new", as: "signup"
  get "/search", to: "static#search", as: "search"
  get "/search_results", to: "static#search_results", as: "search_results"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources :reps
  resources :users
  resources :appointments

  # get '/connect', to: "twilio#connect"
  post '/connect/:apt_id', to: "twilio#connect", as: 'connect'
end
