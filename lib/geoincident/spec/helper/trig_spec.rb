require 'spec_helper'

describe Geoincident::Trig do

  let!(:p1) do
    { lat: 37.982638, lng: 23.67558, heading: 180 }
  end

  let!(:p2) do
    { lat: 37.97541, lng: 23.655324, heading: 90 }
  end

  let!(:distance) { Geoincident::VISIBILITY_RADIUS }

  describe "points intersection" do
    before do
      @p_res = Geoincident::Trig.points_intersection(p1[:lat].to_rad,
                                                     p1[:lng].to_rad,
                                                     p1[:heading].to_rad,
                                                     p2[:lat].to_rad,
                                                     p2[:lng].to_rad,
                                                     p2[:heading].to_rad)
    end

    it "should return a third point with proper coordinates" do
      @p_res[:lat].to_degrees.round(7).should == 37.9754083
      @p_res[:lng].to_degrees.round(7).should == 23.67558
    end
  end

  describe "location distance" do
    before do
      @distance = Geoincident::Trig.location_distance(p1[:lat].to_rad,
                                                      p1[:lng].to_rad,
                                                      p2[:lat].to_rad,
                                                      p2[:lng].to_rad)
    end

    it "should return the distance of two points in meters" do
      @distance.to_i.should == 1951
    end
  end

  describe "destination point" do
    before do
      @p_res = Geoincident::Trig.destination_point(p1[:lat].to_rad,
                                                   p1[:lng].to_rad,
                                                   p1[:heading].to_rad,
                                                   distance)
    end

    it "should return a new destination point" do
      @p_res[:lat].to_degrees.round(7).should == 37.9691633
      @p_res[:lng].to_degrees.round(7).should == 23.67558
    end
  end

  describe "midpoint" do
    before do
      @p_res = Geoincident::Trig.midpoint(p1[:lat].to_rad,
                                          p1[:lng].to_rad,
                                          p2[:lat].to_rad,
                                          p2[:lng].to_rad)
    end

    it "should return a new point" do
      @p_res[:lat].to_degrees.round(7).should == 37.979024
      @p_res[:lng].to_degrees.round(7).should == 23.665452
    end
  end

  describe "perpendicular point" do
    let(:p3) { { lat: 37.973572, lng: 23.66798 } }
    before do
      @p_res = Geoincident::Trig.perpendicular_point(p1[:lat].to_rad, p1[:lng].to_rad,
                                                     p2[:lat].to_rad, p2[:lng].to_rad,
                                                     p3[:lat].to_rad, p3[:lng].to_rad)
    end

    it "should return a new point" do
      @p_res[:lat].to_degrees.round(7).should == 37.9792084
      @p_res[:lng].to_degrees.round(7).should == 23.6659688
    end
  end
end
