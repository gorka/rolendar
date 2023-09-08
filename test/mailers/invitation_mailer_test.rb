require "test_helper"

class InvitationMailerTest < ActionMailer::TestCase
  test "confirm" do
    email = InvitationMailer.with(invitation: invitations(:new)).confirm

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["no-reply@rolendar.com"], email.from
    assert_equal ["invited@rolendar.com"], email.to
    assert_equal "Tienes una nueva invitación", email.subject
  end
end
