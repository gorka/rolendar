Rails.application.routes.draw do
  get "home/index"

  resources :campaigns

  match "/auth/:provider/callback", to: "sessions#create", via: %i[get post], as: :auth_callback
  get "/auth/failure", to: "sessions#failure"
  delete "/sign_out", to: "sessions#destroy"

  root "home#index"
end
