class InvitationPolicy < ApplicationPolicy
  def show?
    guest? || invited?
  end

  private

    def invited?
      resource.user == user
    end
end
