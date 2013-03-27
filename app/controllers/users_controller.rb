class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :show, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @reports = @user.reports
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    @user.roles = Role.viewer

    if @user.save
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:success] = 'User settings updated successfully'

      # update session info for user
      #
      # this is important as the method `current_user` checks the user object
      # not just the user `id`
      sign_in @user

      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:success] = 'User was successfully deleted'
    redirect_to users_url
  end

  private

    def correct_user
      user = User.find(params[:id])
      #todo: redirect to application root
      redirect_to(users_path) unless current_user?(user)
    end
end
