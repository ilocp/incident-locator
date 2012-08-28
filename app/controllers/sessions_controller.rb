class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_to user
    else
      redirect_to signin_path
    end
  end

  def destroy
    sign_out
    redirect_to users_path
  end

end
