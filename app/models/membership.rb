class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :campaign

  validates :user, uniqueness: { scope: :campaign }
  validates :owner, uniqueness: { scope: :campaign }, if: :owner?
end
