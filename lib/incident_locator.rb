#
# some initial support functions / classes
#

class Numeric
  def to_rad
    (self / 180) * Math::PI
  end
end

class Location
  def initialize(lat, lng)
    @lat = lat
    @lng = lng
  end

  attr_accessor :lat, :lng
end


# earth's radius in meters
R = 6371000


##
# Uses the haversine formula to calculate the distance between 2 points.
# The points must respond to lat and lng in decimal degrees.
#
# Returns the distance in meters

def location_distance(p1, p2)
  dLat = (p2.lat - p1.lat).to_rad
  dLng = (p2.lng - p1.lng).to_rad
  lat1 = p1.lat.to_rad
  lat2 = p2.lat.to_rad

  a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.sin(dLng / 2) * Math.sin(dLng / 2) * Math.cos(lat1) * Math.cos(lat2)

  c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

  R * c
end
