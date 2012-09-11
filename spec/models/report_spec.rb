# == Schema Information
#
# Table name: reports
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  latitude    :float
#  longitude   :float
#  heading     :integer
#  incident_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_reports_on_user_id  (user_id)
#

require 'spec_helper'

describe Report do
  let(:user) { FactoryGirl.create(:user) }
  let(:incident) { FactoryGirl.create(:incident) }
  before { @report = user.reports.build(latitude: 10.123456, longitude: 10.123456,
                                       heading: 200) }
  subject { @report }

  it { should respond_to :latitude }
  it { should respond_to :longitude }
  it { should respond_to :heading }
  it { should respond_to :user_id }
  it { should respond_to :incident_id }

  it { should respond_to :user }
  it { should respond_to :incident }
  its(:user) { should == user }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Report.new(user_id: user.id)
      end.to raise_error ActiveModel::MassAssignmentSecurity::Error
    end

    it "should not allow access to report_id" do
      expect do
        Report.new(incident_id: incident.id)
      end.to raise_error ActiveModel::MassAssignmentSecurity::Error
    end
  end

  describe "when user_id is nil" do
    before { @report.user_id = nil }
    it { should_not be_valid }
  end

  describe "with empty location" do

    describe "latitude" do
      before { @report.latitude = nil }
      it { should_not be_valid }
    end

    describe "longitude" do
      before { @report.longitude = nil }
      it { should_not be_valid }
    end

    describe "heading" do
      before { @report.heading = nil }
      it { should_not be_valid }
    end
  end

  describe "with invalid location" do

    describe "latitude" do
      it "should not be valid" do
        invalid_lat = [ 91.0, -91.0, 90.1, -90.1, 'foo' ]
        invalid_lat.each do |lat|
          @report.latitude = lat
          @report.should_not be_valid
        end
      end
    end

    describe "longitude" do
      it "should not be valid" do
        invalid_lng = [ 181.0, -181.0, 180.1, 'foo' ]
        invalid_lng.each do |lng|
          @report.longitude = lng
          @report.should_not be_valid
        end
      end
    end

    describe "heading" do
      it "should not be valid" do
        invalid_headings = [ -1, 361, 150.5, 'foo' ]
        invalid_headings.each do |heading|
          @report.heading = heading
          @report.should_not be_valid
        end
      end
    end
  end

  describe "with valid location" do
    before do
      @new_report = @report.dup
      @new_report.latitude = 1.12345678
      @new_report.longitude = 1.12345678
      @new_report.save
    end

    describe "should have 7 or less decimal digits in coordinates" do
      it { @new_report.latitude.should == @new_report.latitude.round(7) }
      it { @new_report.longitude.should == @new_report.longitude.round(7) }
    end
  end
end
