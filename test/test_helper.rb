ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

module OmniauthHelper
  def omniauth_discord_setup(user)
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new({
      provider: "discord",
      uid: user.discord_uid,
      info: {
        email: user.email,
        name: user.username
      }
    })
  end

  def sign_in_user(user)
    omniauth_discord_setup(user)
    get auth_callback_url("discord")
  end
end
