require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin" do
    before { visit signin_path }
    let(:submit) { "Sign in" }

    describe "page" do
      it { should have_h1('Sign in') }
    end

    describe "with invalid credentials" do
        before { click_button submit }

        it { should have_h1('Sign in') }
        it { should have_error_msg('Invalid') }

        describe "after leaving sign in page" do
          # todo: when we have a home page, point there
          before { visit users_path }
          it { should_not have_error_msg('Invalid') }
        end
    end

    describe "with valid credentials" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_h1(user.name) }
      it { should have_signout_link }
      it { should_not have_signin_link }
      it { should have_link('Settings', href: edit_user_path(user)) }

      describe "followed by sign out" do
        before { click_link "Sign out" }
        it { should have_signin_link }
      end
    end
  end
end
