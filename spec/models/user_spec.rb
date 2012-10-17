# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string(255)
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Tets User", email: "test@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @user.roles = Role.viewer
  end

  subject { @user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :password_digest }
  it { should respond_to :authenticate }

  # associations
  it { should respond_to :reports }
  it { should respond_to :roles }

  # authorization methods
  it { should respond_to :can? }
  it { should respond_to :admin? }
  it { should respond_to :viewer? }
  it { should respond_to :reporter? }

  it { should be_valid }

  describe "when name is blank" do
    before { @user.name = '' }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = 'a' * 51 }
    it { should_not be_valid }
  end

  describe "when email is blank" do
    before { @user.email = '' }
    it { should_not be_valid }
  end

  describe "when email format is valid" do
    it "should be valid" do
      valid_addresses = %w(zomg@foo.com zomg-123@foo.com z_Omg@co.foo.com z+omg@foo.com)
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email format is not valid" do
    it "should not be valid" do
      invalid_addresses = %w(zomg@foo,com zomg123_at_foo.com z_Omg\ co.foo.com zomg@foo.)
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email is already taken" do
    before do
      # emulate a user already in the database with the same email
      user_already_on_db = @user.dup
      # set address to upcase to test for case sensitivity
      user_already_on_db.email = @user.email.upcase
      user_already_on_db.roles = Role.viewer
      user_already_on_db.save
    end
    it { should_not be_valid }
  end

  describe "when password is blank" do
    before { @user.password = @user.password_confirmation = '' }
    it { should_not be_valid }
  end

  describe "when passwords do not match" do
    before { @user.password_confirmation = 'something_different' }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = 'a' * 5 }
    it { should_not be_valid }
  end

  describe "authentication" do
    before { @user.save }
    let (:retrieved_user) { User.find_by_email(@user.email) }

    describe "when password is correct" do
      it { should == retrieved_user.authenticate(@user.password) }
    end

    describe "when password is not correct" do
      # we use this user object more than once
      let(:user_with_invalid_password) { retrieved_user.authenticate("invalid") }

      it { should_not == user_with_invalid_password }
      it { user_with_invalid_password.should be_false }
    end
  end

  describe "association" do
    describe "report" do

      # we want to return user reports in reverse chronological order
      # in user profiles
      before { @user.save }
      let!(:old_report) do
        FactoryGirl.create(:report, user: @user, created_at: 1.day.ago)
      end

      let!(:new_report) do
        FactoryGirl.create(:report, user: @user, created_at: 1.hour.ago)
      end

      it "should return newer report first" do
        @user.reports.should == [new_report, old_report]
      end

      # remove reports when deleting user
      it "should destroy associated reports" do
        reports = @user.reports
        @user.destroy
        reports.each do |report|
          Report.find_by_id(report.id).should be_nil
        end
      end
    end

    describe "role" do
      before { @user.roles = [] }
      it { should_not be_valid }
    end
  end

  describe "authorization" do
    before { @user.save }

    describe "role viewer" do
      before { @user.roles = Role.viewer }
      it "should have the viewer role assigned" do
        expect(@user.viewer?).to be_true
      end
    end

    describe "role reporter" do
      before { @user.roles = Role.reporter }
      it "should have the reporter role assigned" do
        expect(@user.reporter?).to be_true
      end
    end

    describe "role admin" do
      before { @user.roles = Role.admin }
      it "should have the admin role assigned" do
        expect(@user.admin?).to be_true
      end
    end

  end
end

