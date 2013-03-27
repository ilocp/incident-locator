# Using curl to get basic user info:
#
#     curl -s -i -X GET "http://127.0.0.1:3000/api/profile" \
#         -H "Content-type: application/json" \
#         -b /tmp/cookie \
#         -H "X-Csrf-Token: zZJChBamIhboyCv0Zyr7ygEFGJYERUbcCMfpOSS6WNo="
#
# Note that the Csrf token, extracted from the login response must be used.
# Sample response:
#
#     {"email":"test@example.com","name":"testuser"}

module Api
  class UsersController < ApplicationController
    before_filter :signed_in_user
    respond_to :json

    def show
      @user = User.find(current_user.id)
      respond_with @user, only: [:name, :email]
    end
  end
end
