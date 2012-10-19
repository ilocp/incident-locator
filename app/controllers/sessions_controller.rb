class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)

    respond_to do |format|
      if user && user.authenticate(params[:password])
        sign_in user

        format.html { redirect_back_or user }

        json_response = { status: 200, msg: 'Authentication successful' }
        format.json { render json: json_response }
      else
        flash.now[:error] = 'Invalid email/password combination'

        #avoid doing a new request with redirect_to
        format.html { render 'new' }

        json_response = { status: 403, msg: flash.now[:error] }
        format.json { render json: json_response }
      end
    end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end

end
