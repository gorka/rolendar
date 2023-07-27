class CampaignsController < ApplicationController
  before_action :require_authentication

  def index
    @campaigns = Current.user.campaigns.all
  end

  def show
    set_campaign
    authorize_campaign
    @sessions = @campaign.sessions.order(datetime: :asc)
  end

  def new
    @campaign = Current.user.campaigns.new
  end

  def edit
    set_campaign
    authorize_campaign
  end

  def create
    @campaign = Current.user.campaigns.new(campaign_params)

    if @campaign.save
      redirect_to campaign_path(@campaign), notice: "Campaign was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    set_campaign
    authorize_campaign

    if @campaign.update(campaign_params)
      redirect_to campaign_path(@campaign), notice: "Campaign was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    set_campaign
    authorize_campaign

    @campaign.destroy
    redirect_to campaigns_path, notice: "Campaign was successfully destroyed."
  end

  private

    def authorize_campaign
      raise Authentication::NotAuthorizedError if @campaign.user != Current.user
    end

    def campaign_params
      params.require(:campaign).permit(:title)
    end

    def set_campaign
      @campaign = Campaign.find(params[:id])
    end
end