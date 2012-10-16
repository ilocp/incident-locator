class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize

  include SessionsHelper
  include UsersHelper
  include IncidentsHelper

  private

  def authorize
    if current_user
      unless current_user.can?(controller_name, action_name)
        flash[:error] = 'You are not authorized to access this page'
        redirect_to :back
      end
    end
  end
end
