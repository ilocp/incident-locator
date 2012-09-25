module Geoincident

  Numeric.class_eval do
    def to_rad
      self / 180.0 * Math::PI
    end

    def to_degrees
      self * 180.0 / Math::PI
    end
  end

  class Location
    def initialize(lat, lng, heading=nil)
      @lat = lat
      @lng = lng
      @heading = heading
    end

    attr_accessor :lat, :lng, :heading
  end

end
