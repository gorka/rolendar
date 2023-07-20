class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    user_params = {
      omniauth_developer_uid: omniauth_data["provider"] == "developer" ? omniauth_data["uid"] : nil,
      username: omniauth_data["info"]["name"],
      email: omniauth_data["info"]["email"]
    }

    user = User
            .create_with(user_params)
            .find_or_initialize_by(omniauth_developer_uid: user_params[:omniauth_developer_uid])
    
    if user.save
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

  def omniauth_data
    request.env["omniauth.auth"]
  end
end
