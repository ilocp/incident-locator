require 'spec_helper'

describe User do

  before { @user = User.new(name: "Tets User", email: "test@example.com",
                            password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :password_digest }

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
      user_already_on_db.save
    end
    it { should_not be_valid }
  end

end

