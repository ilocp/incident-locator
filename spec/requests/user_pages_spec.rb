require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit new_user_path }

    it { should have_h1('Sign up') }
  end


  describe "users page" do
    before { visit users_path }

    it { should have_h1('All users') }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_h1(user.name) }
  end

  describe "signup" do
    before { visit new_user_path }
    let (:submit) { "Create new account" }

    describe "with invalid user data" do
      it "should not create a user" do
        expect { click_button submit}.not_to change(User, :count)
      end

      describe "after submition" do
        before { click_button submit }
        it { should have_selector('div#error_explanation') }
      end
    end

    describe "with valid user data" do
      before do
        fill_in "Name", with: "Test user"
        fill_in "Email", with: "test@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after submition" do
        before { click_button submit }
        let(:user) { User.find_by_email('test@example.com') }

        it { should have_h1(user.name) }
        it { should have_link('Sign out', href: signout_path) }
      end
    end
  end

end
