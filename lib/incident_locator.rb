#
# some initial support functions / classes
#

class Numeric
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


# earth's radius in meters, same value used in gmaps
# https://developers.google.com/maps/documentation/javascript/reference#spherical
R = 6378137


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

##
# Given 2 points p1 and p2, and 2 headings for these points,
# calculate a third point p3 where the extension lines for
# these points intersect.
def points_intersection(p1, p2)
  lat1 = p1.lat.to_rad
  lng1 = p1.lng.to_rad
  h1 = p1.heading.to_rad

  lat2 = p2.lat.to_rad
  lng2 = p2.lng.to_rad
  h2 = p2.heading.to_rad

  dLat = lat2 - lat1
  dLng = lng2 - lng1

  distance = 2 * Math.asin(Math.sqrt(Math.sin(dLat / 2) * Math.sin(dLat / 2 ) +
                                     Math.cos(lat1) * Math.cos(lat2) *
                                     Math.sin(dLng / 2) * Math.sin(dLng / 2)))

  if distance == 0
    return nil
  end

  # initial/final heading between points
  h_init = Math.acos(
    (Math.sin(lat2) - Math.sin(lat1) * Math.cos(distance)) /
    (Math.sin(distance) * Math.cos(lat1))
  )

  h_final = Math.acos(
    (Math.sin(lat1) - Math.sin(lat2) * Math.cos(distance)) /
    (Math.sin(distance) * Math.cos(lat2))
  )

  if Math.sin(lng2 - lng1) > 0
    h12 = h_init
    h21 = 2 * Math::PI - h_final
  else
    h12 = 2 * Math::PI - h_init
    h21 = h_final
  end

  # calculate angles
  # alpha1 -> angle 2-1-3
  # alpha2 -> angle 1-2-3
  alpha1 = (h1 - h12 + Math::PI) % (2 * Math::PI) - Math::PI
  alpha2 = (h21 - h2 + Math::PI) % (2 * Math::PI) - Math::PI

  alpha1 = alpha1.abs
  alpha2 = alpha2.abs

  # infinite intersections
  if Math.sin(alpha1) == 0 and Math.sin(alpha2) == 0
    return nil
  end

  # ambiguous intersection
  if Math.sin(alpha1) * Math.sin(alpha2) < 0
    return nil
  end

  # calculate intersection point
  alpha3 = Math.acos(-Math.cos(alpha1) * Math.cos(alpha2) +
                     Math.sin(alpha1) * Math.sin(alpha2) * Math.cos(distance))

  distance13 = Math.atan2(Math.sin(distance) * Math.sin(alpha1) * Math.sin(alpha2),
                          Math.cos(alpha2) + Math.cos(alpha1) * Math.cos(alpha3))

  lat3 = Math.asin(Math.sin(lat1) * Math.cos(distance13) +
                   Math.cos(lat1) * Math.sin(distance13) * Math.cos(h1))

  dLng13 = Math.atan2(Math.sin(h1) * Math.sin(distance13) * Math.cos(lat1),
                      Math.cos(distance13) - Math.sin(lat1) * Math.sin(lat3))

  lng3 = lng1 + dLng13
  lng3 = (lng3 + 3 * Math::PI) % (2 * Math::PI) - Math::PI

  Location.new(lat3.to_degrees, lng3.to_degrees)
end


# p1 = Location.new(37.982638,23.67558,180)
# p2 = Location.new(37.97541,23.655324,90)
# p3 = points_intersection(p1, p2)


##
# Given a point p, heading in degrees for this point and a
# maximum distance in meters, calculate a destination point

def destination_point(p, distance=1500)
  lat = p.lat.to_rad
  lng = p.lng.to_rad
  h = p.heading.to_rad

  angular_distance = distance.to_f / R

  new_lat = Math.asin(Math.sin(lat) * Math.cos(angular_distance) +
                      Math.cos(lat) * Math.sin(angular_distance) * Math.cos(h))

  new_lng = lng + Math.atan2(Math.sin(h) * Math.sin(angular_distance) * Math.cos(lat),
                             Math.cos(angular_distance) - Math.sin(lat) * Math.sin(new_lat))

  Location.new(new_lat.to_degrees, new_lng.to_degrees)
end

#p = Location.new(37.982638,23.67558,180)
#p_new = destination_point(p)
#puts "#{p_new.lat}, #{p_new.lng}"
