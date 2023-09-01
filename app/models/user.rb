class User < ApplicationRecord
  has_many :memberships
  has_many :campaigns, through: :memberships
  has_many :sessions, through: :campaigns, source: :sessions

  validates_presence_of :username
end
