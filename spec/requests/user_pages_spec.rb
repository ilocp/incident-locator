require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "users page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit users_path
    end

    it { should have_h1('All users') }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }

    let!(:r1) { FactoryGirl.create(:report, user: user, latitude: 19.0943141,
                                   longitude: 87.9875209) }
    let!(:r2) { FactoryGirl.create(:report, user: user, latitude: 89.0264901,
                                   longitude: 27.8410981) }
    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_h1(user.name) }

    describe "reports" do
      it { should have_selector('h2', text: 'Incident reports') }
      it { should have_selector('div.reports table') }
      it { should have_content(r1.latitude) }
      it { should have_content(r1.longitude) }
      it { should have_content(r2.latitude) }
      it { should have_content(r2.longitude) }
    end
  end

  describe "signup" do
    before { visit new_user_path }
    let (:submit) { "Create new account" }

    describe "page" do
      before { visit new_user_path }

      it { should have_h1('Sign up') }
    end

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
        it { should have_signout_link }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_h1('Edit your profile') }
      it { should have_link('Change gravatar', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid user data" do
      before { click_button "Save changes" }

      it { should have_selector('div#error_explanation') }
    end

    describe "with valid user data" do
      let(:new_name) { "New awesome name" }
      let(:new_email) { "new_email@example.com" }
      let(:new_password) { "new_password" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: new_password
        fill_in "Confirmation", with: new_password
        click_button "Save changes"
      end

      it { should have_success_msg('successfully') }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit users_path
    end

    it { should have_h1('All users') }
    it "should use list to show user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end
end
