module Authentication
  extend ActiveSupport::Concern

  AUTHENTICATION_COOKIE = "cucamonga"

  included do
    before_action :authenticate_user
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
end
