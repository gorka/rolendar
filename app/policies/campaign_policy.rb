class CampaignPolicy < ApplicationPolicy
  def show?
    resource.has_member?(user)
  end

  def update?
    user.present? && resource.owned_by?(user)
  end

  def destroy?
    user.present? && resource.owned_by?(user)
  end
end
