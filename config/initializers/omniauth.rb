Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :discord, Rails.application.credentials.dig(:discord, :client_id), Rails.application.credentials.dig(:discord, :client_secret), scope: "email identify"
end
