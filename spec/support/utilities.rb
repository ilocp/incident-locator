# match h1 elements
RSpec::Matchers.define :have_h1 do |text|
  match do |page|
    page.should have_selector('h1', text: text)
  end
end
