require 'spec_helper'

describe Geoincident::Trig do

  let!(:p1) do
    Geoincident::Location.new(37.982638,23.67558,180)
  end

  let!(:p2) do
    Geoincident::Location.new(37.97541,23.655324,90)
  end

  let!(:distance) { Geoincident::VISIBILITY_RADIUS }

  describe "points_intersection" do
    before { @p_res = Geoincident::Trig.points_intersection(p1, p2) }

    it "should return a third point with proper coordinates" do
      @p_res.lat.round(7).should == 37.9754083
      @p_res.lng.round(7).should == 23.67558
    end
  end

  describe "location distance" do
    before { @dist = Geoincident::Trig.location_distance(p1, p2) }

    it "should return the distance of two points in meters" do
      @dist.to_i.should == 1951
    end
  end

  describe "destination point" do
    before { @p_res = Geoincident::Trig.destination_point(p1, distance) }

    it "should return a new destination point" do
      @p_res.lat.round(7).should == 37.9691633
      @p_res.lng.round(7).should == 23.67558
    end
  end

  describe "midpoint" do
    before { @p_res = Geoincident::Trig.midpoint(p1, p2) }

    it "should return a new point" do
      @p_res.lat.round(7).should == 37.979024
      @p_res.lng.round(7).should == 23.665452
    end
  end

  describe "perpendicular point" do
    let(:p3) { Geoincident::Location.new(37.973572, 23.66798) }
    before { @p_res = Geoincident::Trig.perpendicular_point(p1, p2, p3) }

    it "should return a new point" do
      @p_res.lat.round(7).should == 37.9792084
      @p_res.lng.round(7).should == 23.6659688
    end
  end
end
