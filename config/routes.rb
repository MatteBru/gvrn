Rails.application.routes.draw do
  resources :representatives
  resources :senators
  root to: "static#welcome"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :reps
  resources :users
  resources :appointments

  # get '/connect', to: "twilio#connect"
  post '/connect/:apt_id', to: "twilio#connect", as: 'connect'
end
