class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)

    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'

      #avoid doing a new request with redirect_to
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end

end
