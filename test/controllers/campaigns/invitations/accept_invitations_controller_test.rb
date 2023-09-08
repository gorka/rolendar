require "test_helper"

class Campaigns::InvitationsControllerTest < ActionDispatch::IntegrationTest
  include OmniauthHelper

  # GUEST

  test "a guest can see an invitation" do
    get invitation_url(invitations(:new).token)

    assert_response :success
  end

  test "a guest cannot see an already accepted invitation" do
    get invitation_url(invitations(:accepted).token)

    assert_redirected_to root_path
  end

  test "a guest cannot see an already rejected invitation" do
    get invitation_url(invitations(:rejected).token)

    assert_redirected_to root_path
  end

  test "a guest cannot accept an invitation" do
    get accept_invitation_url(invitations(:new).token)

    assert_redirected_to root_path
  end

  test "a guest cannot accept an already accepted invitation" do
    get accept_invitation_url(invitations(:accepted).token)

    assert_redirected_to root_path
  end

  test "a guest cannot accept an already rejected invitation" do
    get accept_invitation_url(invitations(:rejected).token)

    assert_redirected_to root_path
  end

  # INVITED USER

  test "the invited user can see an invitation" do
    sign_in_user(users(:invited))

    get invitation_url(invitations(:new).token)

    assert_response :success
  end

  test "the invited user cannot see an already accepted invitation" do
    sign_in_user(users(:invited))

    get invitation_url(invitations(:accepted).token)

    assert_redirected_to root_path
  end

  test "the invited user cannot see an already rejected invitation" do
    sign_in_user(users(:invited))

    get invitation_url(invitations(:rejected).token)

    assert_redirected_to root_path
  end

  test "the invited user can accept an invitation" do
    sign_in_user(users(:invited))
    invitation = invitations(:new)

    assert_nil invitation.accepted_at

    get accept_invitation_url(invitation.token)

    assert_redirected_to invitation.campaign
    invitation.reload
    assert_not_nil invitation.accepted_at
  end

  test "the invited user cannot accept an already accepted invitation" do
    sign_in_user(users(:invited))

    get accept_invitation_url(invitations(:accepted).token)

    assert_redirected_to root_path
  end

  test "the invited user cannot accept an already rejected invitation" do
    sign_in_user(users(:invited))

    get accept_invitation_url(invitations(:rejected).token)

    assert_redirected_to root_path
  end

  # MEMBER

  test "a campaign member cannot see an invitation" do
    sign_in_user(users(:member))

    get invitation_url(invitations(:new).token)

    assert_redirected_to root_path
  end

  test "a campaign member cannot see an already accepted invitation" do
    sign_in_user(users(:member))

    get invitation_url(invitations(:accepted).token)

    assert_redirected_to root_path
  end

  test "a campaign member cannot see an already rejected invitation" do
    sign_in_user(users(:member))

    get invitation_url(invitations(:rejected).token)

    assert_redirected_to root_path
  end

  test "a campaign member cannot accept an invitation" do
    sign_in_user(users(:member))

    get accept_invitation_url(invitations(:new).token)

    assert_redirected_to root_path
  end

  test "a campaign member cannot accept an already accepted invitation" do
    sign_in_user(users(:member))

    get accept_invitation_url(invitations(:accepted).token)

    assert_redirected_to root_path
  end

  test "a campaign member cannot accept an already rejected invitation" do
    sign_in_user(users(:member))

    get accept_invitation_url(invitations(:rejected).token)

    assert_redirected_to root_path
  end

  # ANOTHER USER

  test "a random user cannot see an invitation" do
    sign_in_user(users(:user))

    get invitation_url(invitations(:new).token)

    assert_redirected_to root_path
  end

  test "a random user cannot see an already accepted invitation" do
    sign_in_user(users(:user))

    get invitation_url(invitations(:accepted).token)

    assert_redirected_to root_path
  end

  test "a random user cannot see an already rejected invitation" do
    sign_in_user(users(:user))

    get invitation_url(invitations(:rejected).token)

    assert_redirected_to root_path
  end

  test "a random user cannot accept an invitation" do
    sign_in_user(users(:user))

    get accept_invitation_url(invitations(:new).token)

    assert_redirected_to root_path
  end

  test "a random user cannot accept an already accepted invitation" do
    sign_in_user(users(:user))

    get accept_invitation_url(invitations(:accepted).token)

    assert_redirected_to root_path
  end

  test "a random user cannot accept an already rejected invitation" do
    sign_in_user(users(:user))

    get accept_invitation_url(invitations(:rejected).token)

    assert_redirected_to root_path
  end
end
