class RemoveUserIdFromCampaigns < ActiveRecord::Migration[7.0]
  def change
    remove_column :campaigns, :user_id, :bigint
  end
end
