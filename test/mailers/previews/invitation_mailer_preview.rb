# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
class InvitationMailerPreview < ActionMailer::Preview
  def confirm
    InvitationMailer.with(invitation: Invitation.last).confirm
  end
end
