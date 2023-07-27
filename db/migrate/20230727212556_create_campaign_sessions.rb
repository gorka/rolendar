class CreateCampaignSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :campaign_sessions do |t|
      t.belongs_to :campaign, null: false, foreign_key: true
      t.string :title
      t.datetime :datetime, null: false

      t.timestamps
    end
  end
end
