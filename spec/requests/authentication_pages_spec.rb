require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }
    let(:submit) { "Sign in" }

    it { should have_selector('h1', text: 'Sign in') }

    describe "with invalid credentials" do
        before { click_button submit }

        it { should have_selector('h1', text: 'Sign in') }
        it { should have_selector('div.alert-error', text: 'Invalid') }

        describe "after leaving sign in page" do
          # todo: when we have a home page, point there
          before { visit users_path }
          it { should_not have_selector('div.alert-error', text: 'Invalid') }
        end
    end

    describe "with valid credentials" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button submit
      end

      it { should have_selector('h1', text: user.name) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end
end
