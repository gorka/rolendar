require "test_helper"

def sign_in_user(user)
  omniauth_discord_setup(user)
  get auth_callback_url("discord")
end

def new_user
  User.new({
    username: "Pepe",
    email: "pepe@email.com",
    discord_uid: 123
  })
end

class Campaigns::SessionsControllerTest < ActionDispatch::IntegrationTest
  include OmniauthHelper

  setup do
    @valid_data = {
      campaign_session: {
        title: "",
        datetime: Time.now
      }
    }
  end

  # GUEST

  test "cannot see create campaign session form" do
    get new_campaign_session_url(campaigns(:without_sessions))

    assert_response :redirect
  end

  test "cannot see edit campaign session form" do
    get edit_campaign_session_url(campaign_sessions(:one))

    assert_response :redirect
  end

  test "cannot create campaign session" do
    post campaign_sessions_url(campaigns(:without_sessions), params: @valid_data)

    assert_response :redirect
  end

  test "cannot update campaign session" do
    patch campaign_session_url(campaign_sessions(:one), params: @valid_data)

    assert_response :redirect
  end

  test "cannot destroy campaign session" do
    delete campaign_session_url(campaign_sessions(:one))

    assert_response :redirect
  end

  # USER

  test "cannot see create campaign session form for another user's campaign" do
    sign_in_user(new_user)
    get new_campaign_session_url(campaigns(:without_sessions))

    assert_response :redirect
  end

  test "cannot see edit campaign session form for another user's campaign" do
    sign_in_user(new_user)
    get edit_campaign_session_url(campaign_sessions(:one))

    assert_response :redirect
  end

  test "cannot create campaign session for another user's campaign" do
    sign_in_user(new_user)
    post campaign_sessions_url(campaigns(:without_sessions), params: @valid_data)

    assert_response :redirect
  end

  test "cannot update campaign session for another user's campaign" do
    sign_in_user(new_user)
    patch campaign_session_url(campaign_sessions(:one), params: @valid_data)

    assert_response :redirect
  end

  test "cannot destroy campaign session for another user's campaign" do
    sign_in_user(new_user)
    delete campaign_session_url(campaign_sessions(:one))

    assert_response :redirect
  end

  # OWNER

  test "can see create campaign session form for their own campaign" do
    sign_in_user(users(:one))
    get new_campaign_session_url(campaigns(:without_sessions))

    assert_response :success
  end

  test "can see edit campaign session form for their own campaign" do
    sign_in_user(users(:one))
    get edit_campaign_session_url(campaign_sessions(:one))

    assert_response :success
  end

  test "can create campaign session for their own campaign" do
    sign_in_user(users(:one))
    post campaign_sessions_url(campaigns(:without_sessions), params: @valid_data)

    assert_redirected_to campaign_url(campaigns(:without_sessions))
  end

  test "can update campaign session for their own campaign" do
    sign_in_user(users(:one))
    patch campaign_session_url(campaign_sessions(:one), params: @valid_data)

    assert_redirected_to campaign_url(campaign_sessions(:one).campaign)
  end

  test "can destroy campaign session for their own campaign" do
    sign_in_user(users(:one))
    delete campaign_session_url(campaign_sessions(:one))

    assert_redirected_to campaign_url(campaign_sessions(:one).campaign)
  end
end
