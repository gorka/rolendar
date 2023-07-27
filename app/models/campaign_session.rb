class CampaignSession < ApplicationRecord
  belongs_to :campaign, counter_cache: true
end
