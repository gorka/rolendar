require "test_helper"

class Campaigns::InvitationsControllerTest < ActionDispatch::IntegrationTest
  include OmniauthHelper

  # GUEST

  test "cannot create an invitation for a campaign" do
    assert_no_difference("Invitation.count") do
      post campaign_invitations_url(campaigns(:with_invitations))
    end

    assert_redirected_to root_path
  end

  # USER

  test "user cannot create an invitation for another user's campaign" do
    sign_in_user(users(:user))

    assert_no_difference("Invitation.count") do
      post campaign_invitations_url(campaigns(:with_invitations)), params: { invitation: { email: "fake@email.com" } }
    end

    assert_redirected_to root_path
  end

  # OWNER

  test "owner can create an invitation for it's own campaign" do
    sign_in_user(users(:owner))

    assert_difference("Invitation.count") do
      post campaign_invitations_url(campaigns(:with_invitations)), params: { invitation: { email: "fake@email.com" } }
    end

    assert_redirected_to campaign_path(campaigns(:with_invitations))
  end

  test "owner cannot create an invitation for a member of a campaign" do
    sign_in_user(users(:owner))

    assert_no_difference("Invitation.count") do
      post campaign_invitations_url(campaigns(:with_accepted_invitation)), params: { invitation: { email: users(:member).email } }
    end

    assert_response :unprocessable_entity
  end

  test "owner cannot create two invitations for the same user and campaign" do
    sign_in_user(users(:owner))

    assert_no_difference("Invitation.count") do
      post campaign_invitations_url(campaigns(:with_invitations)), params: { invitation: { email: users(:invited).email } }
    end

    assert_response :unprocessable_entity
  end
end
