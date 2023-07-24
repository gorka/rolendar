Rails.application.routes.draw do
  get "home/index"

  scope shallow_prefix: "campaign" do
    resources :campaigns do
      resources :sessions, controller: "campaigns/sessions", shallow: true
    end
  end

  match "/auth/:provider/callback", to: "sessions#create", via: %i[get post], as: :auth_callback
  get "/auth/failure", to: "sessions#failure"
  delete "/sign_out", to: "sessions#destroy"

  root "home#index"
end
