class ApplicationPolicy
  attr_reader :resource, :user

  def initialize(resource, user = Current.user)
    @resource = resource
    @user = user
  end
  
  def self.show?(resource, user = Current.user)
    new(resource, user).show?
  end

  def self.new?(resource, user = Current.user)
    self.create?(resource, user)
  end

  def self.create?(resource, user = Current.user)
    new(resource, user).create?
  end

  def self.edit?(resource, user = Current.user)
    self.update?(resource, user)
  end

  def self.update?(resource, user = Current.user)
    new(resource, user).update?
  end

  def self.destroy?(resource, user = Current.user)
    new(resource, user).destroy?
  end

  private

    def guest?
      !user.present?
    end
end
