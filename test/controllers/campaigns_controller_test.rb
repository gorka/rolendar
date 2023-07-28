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

class CampaignsControllerTest < ActionDispatch::IntegrationTest
  include OmniauthHelper

  # GUEST

  test "cannot see campaigns index" do
    get campaigns_url

    assert_response :redirect
  end

  test "cannot see a campaign" do
    get campaign_url(campaigns(:without_sessions))

    assert_response :redirect
  end

  test "cannot see create campaign form" do
    get new_campaign_url

    assert_response :redirect
  end

  test "cannot see edit campaign form" do
    get edit_campaign_url(campaigns(:without_sessions))

    assert_response :redirect
  end

  test "cannot create campaign" do
    post campaigns_url, params: { campaign: { title: "Masks of Nyarlathotep" } }

    assert_response :redirect
  end

  test "cannot update campaign" do
    patch campaign_url(campaigns(:without_sessions)), params: { campaign: { title: "Masks of Nyarlathotep" } }

    assert_response :redirect
  end

  test "cannot destroy a campaign" do
    delete campaign_url(campaigns(:without_sessions))

    assert_response :redirect
  end

  # USER

  test "can see campaigns index" do
    sign_in_user(new_user)
    get campaigns_url

    assert_response :success
  end

  test "cannot see a campaign from another user" do
    sign_in_user(new_user)
    get campaign_url(campaigns(:without_sessions))

    assert_response :redirect
  end

  test "can see create campaign form" do
    sign_in_user(new_user)
    get new_campaign_url

    assert_response :success
  end

  test "cannot see edit campaign form from another user" do
    sign_in_user(new_user)
    get edit_campaign_url(campaigns(:without_sessions))

    assert_response :redirect
  end

  test "can create campaign" do
    sign_in_user(new_user)
    post campaigns_url, params: { campaign: { title: "Masks of Nyarlathotep" } }

    assert_redirected_to Campaign.last
  end

  test "cannot update campaign from another user" do
    sign_in_user(new_user)
    patch campaign_url(campaigns(:without_sessions)), params: { campaign: { title: "Masks of Nyarlathotep" } }

    assert_response :redirect
  end

  test "cannot destroy a campaign from another user" do
    sign_in_user(new_user)
    delete campaign_url(campaigns(:without_sessions))

    assert_response :redirect
  end

  # OWNER

  test "cann see one of their campaigns" do
    sign_in_user(users(:one))
    get campaign_url(campaigns(:without_sessions))

    assert_response :success
  end

  test "can see edit campaign form of one of their campaigns" do
    sign_in_user(users(:one))
    get edit_campaign_url(campaigns(:without_sessions))

    assert_response :success
  end

  test "can update one of their campaigns" do
    sign_in_user(users(:one))
    patch campaign_url(campaigns(:without_sessions)), params: { campaign: { title: "Masks of Nyarlathotep" } }

    assert_redirected_to campaign_url(campaigns(:without_sessions))
  end

  test "can destroy one of their campaigns" do
    sign_in_user(users(:one))
    delete campaign_url(campaigns(:without_sessions))

    assert_redirected_to campaigns_url
  end
end
