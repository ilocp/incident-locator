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
