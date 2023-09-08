class CampaignsController < ApplicationController
  before_action :require_authentication

  def index
    @campaigns = Current.user.campaigns.all
  end

  def show
    set_campaign
    can_see_campaign
    
    @invitation = @campaign.invitations.new
  end

  def new
    @campaign = Campaign.new
  end

  def edit
    set_campaign
    can_admin_campaign
  end

  def create
    @campaign = Campaign.new(campaign_params)

    if @campaign.save
      redirect_to campaign_path(@campaign), notice: "Campaign was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    set_campaign
    can_admin_campaign

    if @campaign.update(campaign_params)
      redirect_to campaign_path(@campaign), notice: "Campaign was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    set_campaign
    can_admin_campaign

    @campaign.destroy
    redirect_to campaigns_path, notice: "Campaign was successfully destroyed."
  end

  private

    def can_see_campaign
      raise Authentication::NotAuthorizedError unless @campaign.has_member?(Current.user)
    end

    def can_admin_campaign
      raise Authentication::NotAuthorizedError unless @campaign.owned_by?(Current.user)
    end

    def campaign_params
      params.require(:campaign).permit(:title)
    end

    def set_campaign
      @campaign = Campaign.find(params[:id])
    end
end
