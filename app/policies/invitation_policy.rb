class InvitationPolicy < ApplicationPolicy
  def show?
    guest? || invited?
  end

  def create?
    resource.owned_by?(user)
  end

  private

    def invited?
      resource.user == user || resource.email == user.email
    end
end
