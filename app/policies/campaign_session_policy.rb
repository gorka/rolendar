class CampaignSessionPolicy < ApplicationPolicy
  def show?
    resource.has_member?(user)
  end

  def create?
    user.present? && resource.owned_by?(user)
  end

  def update?
    user.present? && resource.campaign.owned_by?(user)
  end

  def destroy?
    user.present? && resource.campaign.owned_by?(user)
  end
end
