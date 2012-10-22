module Api
  class SessionsController < ApplicationController
    respond_to :json

    def create
      user = User.find_by_email(params[:email].downcase)

      if user && user.authenticate(params[:password])
        sign_in user

        # set a crsf token in the response headers for the current session
        # every POST/PUT/DELETE request using the API must supplie this to
        # be considered valid
        response.headers['X-CSRF-Token'] = form_authenticity_token.to_s

        respond_with({ msg: 'Authentication successful' }, status: :ok, location: nil)
      else
        respond_with({ msg: 'Invalid email/password combination' }, status: :forbidden,
                     location: nil)
      end
    end
  end
end
