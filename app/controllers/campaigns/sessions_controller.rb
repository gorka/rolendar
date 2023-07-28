class Campaigns::SessionsController < ApplicationController
  before_action :require_authentication

  def new
    set_campaign
    can_admin_campaign
    
    @session = @campaign.sessions.new
  end

  def edit
    set_session
    can_admin_campaign
  end

  def create
    set_campaign
    can_admin_campaign

    @session = @campaign.sessions.new(session_params)
    
    if @session.save
      redirect_to campaign_path(@campaign), notice: "Session was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    set_session
    can_admin_campaign

    if @session.update(session_params)
      redirect_to campaign_path(@session.campaign), notice: "Session was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    set_session
    can_admin_campaign

    @session.destroy
    redirect_to campaign_path(@session.campaign), notice: "Session was successfully destroyed."
  end

  private

    def can_admin_campaign
      campaign = @campaign || @session.campaign
      raise Authentication::NotAuthorizedError unless campaign.owned_by?(Current.user)
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
