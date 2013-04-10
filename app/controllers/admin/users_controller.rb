module Admin
  class UsersController < ApplicationController
    before_filter :signed_in_user
    before_filter :admin_user

    def index
      @users = User.all
    end

    def grant_reporter
      @user = User.find(params[:id])

      if @user && !@user.reporter?
        @user.roles << Role.reporter
        flash[:success] = 'User granted report privileges successfully'
      else
        flash[:error] = 'Cannot find user or user is already a reporter'
      end

      redirect_to admin_users_path
    end

  end
end
