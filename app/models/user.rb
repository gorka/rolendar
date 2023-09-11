class User < ApplicationRecord
  has_many :memberships
  has_many :campaigns, through: :memberships
  has_many :sessions, through: :campaigns, source: :sessions
  has_many :sent_invitations, class_name: "Invitation", foreign_key: "owner_id"
  has_many :received_invitations, class_name: "Invitation", foreign_key: "user_id"

  validates_presence_of :username

  def has_pending_invitations?
    received_invitations.pending.any?
  end
end
