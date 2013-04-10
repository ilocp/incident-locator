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

  def is_admin?
    self.current_user.admin?
  end

  def redirect_back_or(default_url)
    redirect_to(session[:return_to] || default_url)
    session.delete(:return_to)
  end

  private

    def current_user=(user)
      # set the current user object
      @current_user = user
    end

    def current_user?(user)
      user == current_user
    end

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: 'You need to sign in to access this page'
      end
    end

    def admin_user
      unless is_admin?
        redirect_to root_path, notice: 'Not enough permissions to access this resource'
      end
    end

    def store_location
      session[:return_to] = request.url
    end

end
