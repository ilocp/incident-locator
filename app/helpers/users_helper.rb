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

end
