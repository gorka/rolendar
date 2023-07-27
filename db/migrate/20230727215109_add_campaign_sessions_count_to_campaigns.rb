class AddCampaignSessionsCountToCampaigns < ActiveRecord::Migration[7.0]
  def change
    add_column :campaigns, :campaign_sessions_count, :integer, null: false, default: 0
  end
end
