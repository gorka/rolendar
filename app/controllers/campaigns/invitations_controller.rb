class Campaigns::InvitationsController < ApplicationController
  before_action :require_authentication, only: %i[ accept create ]

  def show
    set_invitation
    redirect_if_accepted_or_rejected
    redirect_if_not_for_current_user
    
  end
  
  def accept
    set_invitation
    redirect_if_accepted_or_rejected
    redirect_if_not_for_current_user

    @invitation.accept!

    redirect_to @invitation.campaign
  end

  def create
    set_campaign

    @invitation = @campaign.invitations.new(invitation_params)
    user = User.find_by(email: invitation_params.fetch(:email))
    @invitation.user = user

    if @campaign.members.include?(user)
      @invitation.errors.add(:base, message: "You can't invite someone that is already playing this campaign.")
      render "campaigns/show", status: :unprocessable_entity
      return
    end

    if @invitation.save
      redirect_to campaign_path(params[:campaign_id]), notice: "Invitation was sent successfully."
    else
      render "campaigns/show", status: :unprocessable_entity
    end
  end

  private

    def set_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end

    def set_invitation
      @invitation = Invitation.find_by(token: params[:token])
    end

    def invitation_params
      params.require(:invitation).permit(:email)
    end

    def redirect_if_accepted_or_rejected
      # todo: if accepted by user, redirect to campaign

      if @invitation.accepted? || @invitation.rejected?
        redirect_to root_path and return
      end
    end

    def redirect_if_not_for_current_user
      if Current.user && @invitation.user != Current.user
        redirect_to root_path and return
      end
    end
end
