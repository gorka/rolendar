class AddMembershipUserIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :memberships, [:user_id, :campaign_id], unique: true
  end
end
