class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  PROVIDERS = {
    developer: "developer",
    discord: "discord"
  }.freeze

  def create
    user = User
            .create_with(user_params)
            .find_or_initialize_by(find_params) unless find_params.empty?
    
    if user && user.save
      set_authentication_cookie(user)
      redirect_to request.env["omniauth.origin"], notice: "Te has conectado correctamente."
    else
      redirect_to root_path, alert: "Ha ocurrido un error."
    end
  end

  def destroy
    cookies.delete(AUTHENTICATION_COOKIE)

    redirect_to root_path, notice: "Te has desconectado correctamente."
  end

  private

  def find_params
    case provider
    when PROVIDERS[:developer]
      { omniauth_developer_uid: user_params[:omniauth_developer_uid] }
    when PROVIDERS[:discord]
      { discord_uid: user_params[:discord_uid] }
    else
      {}
    end
  end

  def omniauth_data
    request.env["omniauth.auth"]
  end

  def provider
    omniauth_data["provider"]
  end

  def user_params
    user_data = {
      username: omniauth_data["info"]["name"],
      email: omniauth_data["info"]["email"]
    }

    case provider
    when PROVIDERS[:developer]
      user_data[:omniauth_developer_uid] = omniauth_data["uid"]
    when PROVIDERS[:discord]
      user_data[:discord_uid] = omniauth_data["uid"]
    end

    user_data
  end
end
