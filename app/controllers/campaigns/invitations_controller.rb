class Campaigns::InvitationsController < ApplicationController
  before_action :require_authentication, only: %i[ index accept create ]

  def index
    @invitations = Current.user.received_invitations.pending
  end

  def show
    set_invitation
    redirect_to root_path and return if accepted_or_rejected
    authorize InvitationPolicy.show?(@invitation)
  end
  
  def accept
    set_invitation
    redirect_to root_path and return if accepted_or_rejected
    authorize InvitationPolicy.show?(@invitation)

    @invitation.accept!

    redirect_to @invitation.campaign
  end

  def create
    set_campaign
    authorize InvitationPolicy.create?(@campaign)

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

    def accepted_or_rejected
      # todo: if accepted by user, redirect to campaign
      @invitation.accepted? || @invitation.rejected?
    end

    def not_for_current_user
      Current.user && @invitation.user != Current.user
    end
end
