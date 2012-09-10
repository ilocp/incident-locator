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
      before { sign_in user }

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

  describe "authorization" do
    let(:user) { FactoryGirl.create(:user) }

    describe "before sign-in" do

      describe "in Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_h1('Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the index page" do
          before { visit users_path }
          it { should have_h1('Sign in') }
        end
      end

      describe "in Reports controller" do

        describe "submiting new report" do
          before { post reports_path }
          specify { response.should redirect_to(signin_path) }
        end
      end
    end

    describe "after sign-in" do
      before { sign_in user }
      it { should have_h1(user.name) }

      describe "in Users controller" do

        describe "as wrong user" do
          let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }

          describe "visit the edit page" do
            before { visit edit_user_path(wrong_user) }
            it { should_not have_h1('Edit your profile') }
            it { should have_signout_link }
          end

          describe "submitting to the update action" do
            # Note: this isn't supported from all drivers
            # direct http requests are not supported by capybara sessions
            # this can be bypassed using cookies, eg:
            # http://is.gd/lPZ34w
            before { page.driver.put user_path(wrong_user) }
            specify { page.driver.status_code.should_not == 200 }
          end
        end
      end
    end

    describe "with proper redirects" do
      # visiting the edit action while not logged in
      # should prompt for login and then redirect to the
      # edit action
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          sign_in user
        end

        describe "after sign-in" do
          it "should redirect to the requested protected page" do
            page.should have_h1('Edit your profile')
            page.should have_signout_link
          end

          # the previous requested url should be removed from the session
          # so a normal login action should redirect to the user profile
          describe "when sign out and then sign in again" do
            before do
              click_link "Sign out"
              visit signin_path
              sign_in user
            end

            it "should redirect to user profile page" do
              page.should have_h1(user.name)
              page.should have_signout_link
            end
          end
        end
      end
    end

  end
end
