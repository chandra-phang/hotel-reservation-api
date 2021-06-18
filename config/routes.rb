Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'
  post "signup", to: "users#create"

  get "users", to: "users#index"
  get "users/:id", to: "users#show"
  post "users", to: "users#create"
  patch "users/:id", to: "users#update"
  delete "users/:id", to: "users#destroy"

  get "reservations", to: "reservations#index"
  get "reservations/:id", to: "reservations#show"
  post "reservations", to: "reservations#create"
  patch "reservations/:id", to: "reservations#update"
  delete "reservations/:id", to: "reservations#destroy"
end
