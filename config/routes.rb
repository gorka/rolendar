Rails.application.routes.draw do
  get 'home/index'

  match '/auth/:provider/callback', to: 'sessions#create', via: %i[get post], as: :auth_callback
  get '/auth/failure', to: 'sessions#failure'

  root "home#index"
end
