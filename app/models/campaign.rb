class Campaign < ApplicationRecord
  has_many :sessions, -> { order(datetime: :desc) }, class_name: "CampaignSession"
  has_many :memberships, dependent: :destroy
  has_many :members, -> { includes(:memberships).order("memberships.created_at": :asc) }, through: :memberships, source: :user
  has_many :invitations

  validates_presence_of :title

  after_create :create_owner_membership

  def has_member?(user)
    members.include?(user)
  end

  def owned_by?(user)
    user == owner
  end

  def owner
    memberships.find_by(owner: true).user
  end

  private

    def create_owner_membership
      memberships.create({
        user: Current.user,
        owner: true
      })
    end
end
