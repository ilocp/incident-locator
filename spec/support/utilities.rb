# match h1 elements
RSpec::Matchers.define :have_h1 do |text|
  match do |page|
    page.should have_selector('h1', text: text)
  end
end

# matchers for each flash message type
# eg:
#
#   `:have_error_msg` checks for `div.alert-error` elements
#   with supplied text
#
flash_types = ['error', 'success', 'notice']
flash_types.each do |flash_type|

  matcher_name = "have #{flash_type} msg"

  # define the actual matcher
  RSpec::Matchers.define matcher_name.parameterize.underscore.to_sym do |msg|
    match do |page|
      page.should have_selector("div.alert-#{flash_type}", text: msg)
    end
  end
end

# sign in with valid credentials
def valid_signin(user)
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end
