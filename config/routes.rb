Rails.application.routes.draw do
  get "home/index"

  resources :campaigns do
    scope shallow_prefix: "campaign" do
      resources :sessions, only: %i[ new edit create update destroy ], controller: "campaigns/sessions", shallow: true
    end
  end

  match "/auth/:provider/callback", to: "sessions#create", via: %i[get post], as: :auth_callback
  get "/auth/failure", to: "sessions#failure"
  delete "/sign_out", to: "sessions#destroy"

  root "home#index"
end
