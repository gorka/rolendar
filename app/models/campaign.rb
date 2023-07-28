class Campaign < ApplicationRecord
  belongs_to :user
  has_many :sessions, class_name: "CampaignSession"

  validates_presence_of :title
end
