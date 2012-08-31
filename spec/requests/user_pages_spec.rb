require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit new_user_path }

    it { should have_selector('h1', text: 'Sign up') }
  end

  describe "users page" do
    before { visit users_path }

    it { should have_selector('h1', text: 'All users') }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
  end

end
