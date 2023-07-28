class User < ApplicationRecord
  has_many :memberships
  has_many :campaigns, through: :memberships

  validates_presence_of :username
end
