require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  include OmniauthHelper

  test "creates new user if does not exist" do
    user = User.new({
      username: "Pepe",
      email: "pepe@email.com",
      discord_uid: 110
    })
    omniauth_discord_setup(user)

    assert_difference "User.count", 1 do
      get auth_callback_url("discord")
    end

    assert_redirected_to root_path
  end

  test "does not create new user if exists" do
    omniauth_discord_setup(users(:one))

    assert_no_difference "User.count" do
      get auth_callback_url("discord")
    end

    assert_redirected_to root_path
  end

  test "does not create with invalid info" do
    OmniAuth.config.mock_auth[:discord] = :invalid_credentials

    assert_no_difference "User.count" do
      get auth_callback_url("discord")
    end

    follow_redirect!
    assert_redirected_to root_path
  end
end
