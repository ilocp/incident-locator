require 'spec_helper'

describe "Admin pages" do

  subject { page }

  # create users with 3 different permissions
  let(:viewer) { FactoryGirl.create(:user) }
  let(:reporter) { FactoryGirl.create(:reporter) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe "users page" do
    describe "when not logged in" do
      before { visit admin_users_path }

      it "should redirect to the login page" do
        page.should have_h1('Sign in')
        page.should have_notice_msg('sign in')
      end
    end

    describe "when logged in as viewer" do
      before do
        sign_in viewer
        visit admin_users_path
      end

      it "should redirect to home page" do
        page.should have_selector('div.map_container div#map')
      end
    end

    describe "when logged in as reporter" do
      before do
        sign_in reporter
        visit admin_users_path
      end

      it "should redirect to home page" do
        page.should have_selector('div.map_container div#map')
      end
    end

    describe "when logged in as admin" do
      before do
        sign_in admin
        visit admin_users_path
      end

      it { should have_h1('All users') }
      it "should use list to show all users" do
        User.all.each do |user|
          page.should have_selector('li', text: user.name)
          page.should have_selector('li p', Role.viewer[0].name)
        end
      end
    end
  end

  describe "grant reporter" do
    let!(:non_reporter) { FactoryGirl.create(:user) }

    describe "as non admin" do
      before do
        sign_in viewer
        visit admin_grant_reporter_path(non_reporter)
      end

      it "should not allow access" do
        expect(current_path).to eq(root_path)
      end

      it "should not update user roles" do
        expect(non_reporter.roles).to eq(Role.viewer)
      end
    end

    describe "as admin user" do
      before { sign_in admin }

      describe "on a non-reporter user" do
        before { visit admin_grant_reporter_path(non_reporter) }

        it "should add the reporter role to that user" do
          expect(non_reporter.reporter?).to eq(true)
        end

        it "should redirect to the admin users page" do
          expect(current_path).to eq(admin_users_path)
        end

        it "should have a successful flash message" do
          page.should have_success_msg('privileges successfully')
        end
      end

      describe "on a user who is already a reporter" do
        before { visit admin_grant_reporter_path(reporter) }

        it "should redirect to the admin users page" do
          expect(current_path).to eq(admin_users_path)
        end

        it "should have error flash message" do
          page.should have_error_msg('Cannot find user or user is already a reporter')
        end

        it "should not alter this user's role" do
          expect(reporter.reporter?).to eq(true)
        end
      end

    end
  end
end
