module SessionsHelper

  def current_user
    # find and return the current user object
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def sign_in(user)
    # handle user login
    session[:user_id] = user.id
    self.current_user = user
  end

  def sign_out
    session[:user_id] = nil
    self.current_user = nil
  end

  def signed_in?
    ! self.current_user.nil?
  end

  private

    def current_user=(user)
      # set the current user object
      @current_user = user
    end

end
