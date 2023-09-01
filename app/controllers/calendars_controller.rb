class CalendarsController < ApplicationController
  before_action :require_authentication

  def show
    @sessions = Current.user.sessions.includes(:campaign)
  end
end
