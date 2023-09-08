class InvitationMailer < ApplicationMailer
  def confirm
    @invitation = params[:invitation]
    @name = @invitation.try(:user).try(:username)

    mail(to: @invitation.email, subject: "Tienes una nueva invitación")
  end
end
