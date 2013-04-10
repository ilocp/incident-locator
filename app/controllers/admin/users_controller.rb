module Admin
  class UsersController < ApplicationController
    before_filter :signed_in_user
    before_filter :admin_user

    def index
      @users = User.all
    end
  end
end
