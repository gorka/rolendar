module Authorization
  extend ActiveSupport::Concern

  class NotAuthorizedError < StandardError; end

  included do
    rescue_from NotAuthorizedError, with: :redirect_if_not_authorized
  end

  def authorize(authorization)
    raise NotAuthorizedError unless authorization
  end

  private

  def redirect_if_not_authorized
    redirect_to root_path, alert: "You're not authorized to perform this action."
  end
end
