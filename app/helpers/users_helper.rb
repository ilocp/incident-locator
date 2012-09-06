module UsersHelper

  def gravatar_for(user, options = { size: 80, rating: 'g', ssl: true })
    hash = Digest::MD5::hexdigest(user.email.downcase)

    # build the request url for gravatar
    if options[:ssl]
      url = 'https://secure.gravatar.com/'
    else
      url = 'http://www.gravatar.com/'
    end
    url = "#{url}avatar/#{hash}?s=#{options[:size]}&r#{options[:rating]}"

    image_tag(url, alt: user.name, class: 'gravatar')
  end

  private

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: 'You need to sign in to access this page'
      end
    end

    def correct_user
      @user = User.find(params[:id])
      #todo: redirect to application root
      redirect_to(users_path) unless current_user?(@user)
    end

end
