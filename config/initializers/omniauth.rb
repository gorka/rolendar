Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer if Rails.env.development?
  provider :discord, Rails.application.credentials.discord.client_id, Rails.application.credentials.discord.client_secret, scope: "email identify"
end
