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
end
