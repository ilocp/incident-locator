class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)

    respond_to do |format|
      if user && user.authenticate(params[:password])
        sign_in user

        format.html { redirect_back_or user }

        json_response = { msg: 'Authentication successful' }
        format.json { render json: json_response, status: :ok }
      else
        flash.now[:error] = 'Invalid email/password combination'

        #avoid doing a new request with redirect_to
        format.html { render 'new' }

        json_response = { msg: flash.now[:error] }
        format.json { render json: json_response, status: :forbidden }
      end
    end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end

end
