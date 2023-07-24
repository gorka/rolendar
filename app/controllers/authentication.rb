module Authentication
  extend ActiveSupport::Concern

  class NotAuthorizedError < StandardError
    def initialize(msg = "You are not authorized.")
      super(msg)
    end
  end

  AUTHENTICATION_COOKIE = "cucamonga"

  included do
    before_action :authenticate_user

    rescue_from NotAuthorizedError, with: :redirect_if_not_authorized
  end

  protected

  def set_authentication_cookie(user)
    cookies.encrypted[AUTHENTICATION_COOKIE] = user.id
  end

  private

  def authenticate_user
    if user = User.find_by(id: authentication_cookie)
      Current.user = user
    end
  end

  def authentication_cookie
    cookies.encrypted[AUTHENTICATION_COOKIE]
  end

  def redirect_if_not_authorized
    redirect_to root_path, alert: "You're not authorized to perform this action."
  end

  def require_authentication
    raise NotAuthorizedError.new unless Current.user
  end
end
