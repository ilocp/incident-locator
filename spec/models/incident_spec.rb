# == Schema Information
#
# Table name: incidents
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  radius     :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Incident do
  before { @incident = Incident.new(latitude: 10.1234567, longitude: 30.7654321, radius: 200) }

  subject { @incident }

  it { should respond_to :latitude }
  it { should respond_to :longitude }
  it { should respond_to :radius }

  it { should be_valid }

  describe "with empty location" do

    describe "latitude" do
      before { @incident.latitude = nil }
      it { should_not be_valid }
    end

    describe "longitude" do
      before { @incident.longitude = nil }
      it { should_not be_valid }
    end

    describe "radius" do
      before { @incident.radius = nil }
      it { should_not be_valid }
    end
  end

  describe "with invalid location" do

    describe "latitude" do
      it "should not be valid" do
        invalid_lat = [ 91.0, -91.0, 90.1, -90.1, 'foo' ]
        invalid_lat.each do |lat|
          @incident.latitude = lat
          @incident.should_not be_valid
        end
      end
    end

    describe "longitude" do
      it "should not be valid" do
        invalid_lng = [ 181.0, -181.0, 180.1, 'foo' ]
        invalid_lng.each do |lng|
          @incident.longitude = lng
          @incident.should_not be_valid
        end
      end
    end

    describe "radius" do
      it "should not be valid" do
        invalid_radius = [ -1, 0, 'foo' ]
        invalid_radius.each do |radius|
          @incident.radius = radius
          @incident.should_not be_valid
        end
      end
    end
  end

end
