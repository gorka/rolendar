class Campaigns::SessionsController < ApplicationController
  before_action :require_authentication

  def new
    set_campaign
    authorize_campaign
    @session = @campaign.sessions.new
  end

  def create
    set_campaign
    authorize_campaign

    @session = @campaign.sessions.new(session_params)

    if @session.save
      redirect_to campaign_url(@campaign), notice: "Session was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    set_session
    authorize_campaign

    @session.destroy
    redirect_to campaign_path(@session.campaign), notice: "Sessions was successfully destroyed."
  end

  private

    def authorize_campaign
      campaign = @campaign || @session.campaign
      redirect_to root_path, alert: "Yo cannot see this resource." if campaign.user != Current.user
      return
    end

    def set_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end

    def set_session
      @session = CampaignSession.find(params[:id])
    end

    def session_params
      params.require(:campaign_session).permit(:title, :datetime)
    end
end
