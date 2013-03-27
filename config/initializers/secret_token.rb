# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.


if ENV['SECRET_TOKEN'].blank?
  if Rails.env.test?
    ENV['SECRET_TOKEN'] = SecureRandom.hex(30)
  else
    raise "You must set ENV[\"SECRET_TOKEN\"] in your app's config vars"
  end
end

IncidentLocator::Application.config.secret_token = ENV['SECRET_TOKEN']
