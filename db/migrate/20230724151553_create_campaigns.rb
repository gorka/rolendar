class CreateCampaigns < ActiveRecord::Migration[7.0]
  def change
    create_table :campaigns do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :title, null: false

      t.timestamps
    end
  end
end
