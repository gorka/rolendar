require "application_system_test_case"

class OmniauthsTest < ApplicationSystemTestCase
  include OmniauthHelper

  setup do
    user = users(:one)
    omniauth_discord_setup(user)

    OmniAuth.config.on_failure = Proc.new { |env|
      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    }
  end

  test "sign in user with valid credentials" do
    visit root_url
    click_button "Login with Discord"
    assert_selector "button", text: "Desconectar"
    assert_selector "div", text: "Te has conectado correctamente."
  end

  test "sign in user with invalid credentials" do
    OmniAuth.config.mock_auth[:discord] = :invalid_credentials

    visit root_url
    click_button "Login with Discord"
    refute_selector "button", text: "Desconectar"
    assert_selector "div", text: "Ha ocurrido un error."
  end
end
