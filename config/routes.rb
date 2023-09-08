Rails.application.routes.draw do
  get "home/index"

  resource :calendar, only: %i[ show ]
  resources :campaigns do
    scope shallow_prefix: "campaign" do
      resources :sessions, only: %i[ new edit create update destroy ], controller: "campaigns/sessions", shallow: true
      resources :invitations, only: %i[ create ], controller: "campaigns/invitations", shallow: true
    end
  end
  resources :invitations, only: %i[ show ], controller: "campaigns/invitations", param: :token

  get "/invitations/:token/accept", to: "campaigns/invitations#accept", as: :accept_invitation

  match "/auth/:provider/callback", to: "sessions#create", via: %i[get post], as: :auth_callback
  get "/auth/failure", to: "sessions#failure"
  delete "/sign_out", to: "sessions#destroy"

  root "home#index"
end
