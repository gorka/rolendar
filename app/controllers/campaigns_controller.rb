class CampaignsController < ApplicationController
  before_action :require_authentication
  before_action :set_campaign, only: %i[ show edit update destroy ]

  def index
    @campaigns = Current.user.campaigns.all
  end

  def show
    authorize_campaign

    @sessions = @campaign.sessions.order(datetime: :asc)
  end

  def new
    @campaign = Current.user.campaigns.new
  end

  def edit
    authorize_campaign
  end

  def create
    @campaign = Current.user.campaigns.new(campaign_params)

    if @campaign.save
      redirect_to campaign_url(@campaign), notice: "Campaign was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize_campaign
    if @campaign.update(campaign_params)
      redirect_to campaign_url(@campaign), notice: "Campaign was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_campaign
    @campaign.destroy

    redirect_to campaigns_url, notice: "Campaign was successfully destroyed."
  end

  private
    def authorize_campaign
      redirect_to root_path, alert: "Yo cannot see this resource." if @campaign.user != Current.user
      return
    end

    def campaign_params
      params.require(:campaign).permit(:user_id, :title)
    end

    def set_campaign
      @campaign = Campaign.find(params[:id])
    end
end
