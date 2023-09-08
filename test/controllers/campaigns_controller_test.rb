require "test_helper"

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

    assert_redirected_to root_path
  end

  test "cannot see a campaign" do
    get campaign_url(campaigns(:without_sessions))

    assert_redirected_to root_path
  end

  test "cannot see create campaign form" do
    get new_campaign_url

    assert_redirected_to root_path
  end

  test "cannot see edit campaign form" do
    get edit_campaign_url(campaigns(:without_sessions))

    assert_redirected_to root_path
  end

  test "cannot create campaign" do
    post campaigns_url, params: { campaign: { title: "Masks of Nyarlathotep" } }

    assert_redirected_to root_path
  end

  test "cannot update campaign" do
    patch campaign_url(campaigns(:without_sessions)), params: { campaign: { title: "Masks of Nyarlathotep" } }

    assert_redirected_to root_path
  end

  test "cannot destroy a campaign" do
    delete campaign_url(campaigns(:without_sessions))

    assert_redirected_to root_path
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

    assert_redirected_to root_path
  end

  test "can see create campaign form" do
    sign_in_user(new_user)
    get new_campaign_url

    assert_response :success
  end

  test "cannot see edit campaign form from another user" do
    sign_in_user(new_user)
    get edit_campaign_url(campaigns(:without_sessions))

    assert_redirected_to root_path
  end

  test "can create campaign" do
    sign_in_user(new_user)
    post campaigns_url, params: { campaign: { title: "Masks of Nyarlathotep" } }

    assert_redirected_to Campaign.last
  end

  test "cannot update campaign from another user" do
    sign_in_user(new_user)
    patch campaign_url(campaigns(:without_sessions)), params: { campaign: { title: "Masks of Nyarlathotep" } }

    assert_redirected_to root_path
  end

  test "cannot destroy a campaign from another user" do
    sign_in_user(new_user)
    delete campaign_url(campaigns(:without_sessions))

    assert_redirected_to root_path
  end

  # MEMBER

  test "can see a campaign is member of" do
    sign_in_user(users(:member))
    get campaign_url(campaigns(:with_sessions))

    assert_response :success
  end

  test "cannot see edit campaign form of a campaign is member of" do
    sign_in_user(users(:member))
    get edit_campaign_url(campaigns(:with_sessions))

    assert_redirected_to root_path
  end

  test "cannot update a campaign is member of" do
    sign_in_user(users(:member))
    patch campaign_url(campaigns(:with_sessions)), params: { campaign: { title: "Masks of Nyarlathotep" } }

    assert_redirected_to root_path
  end

  test "cannot destroy a campaign is member of" do
    sign_in_user(users(:member))
    delete campaign_url(campaigns(:with_sessions))

    assert_redirected_to root_path
  end

  # OWNER

  test "can see one of their campaigns" do
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
