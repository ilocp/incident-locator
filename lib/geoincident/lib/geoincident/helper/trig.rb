#
# Helper trigonometric functions
#
# All values accepted by these functions must be in radians.
# Caller functions must format the input/output values accordingly to
# radians / degrees.
#
# Some functions return location points. These points are represented as
# hashes with keys: `lat` and `lng` and the values are in radians.
# Eg:
#   { lat: 90.244561, lng: 46.329010 }
#
# Returned values that represent distances are in meters.

module Geoincident
  module Trig

    extend self

    # earth's radius in meters, same value used in gmaps
    # https://developers.google.com/maps/documentation/javascript/reference#spherical
    R = 6378137

    # set some helper constants defining coordinate limits
    LAT_MIN = -90.to_rad
    LAT_MAX = 90.to_rad
    LNG_MIN = -180.to_rad
    LNG_MAX = 180.to_rad

    ##
    # Uses the haversine formula to calculate the distance between 2 points.
    #
    # Returns the distance in meters
    def location_distance(lat1, lng1, lat2, lng2)
      dLat = lat2 - lat1
      dLng = lng2 - lng1

      a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.sin(dLng / 2) * Math.sin(dLng / 2) * Math.cos(lat1) * Math.cos(lat2)

      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

      R * c
    end

    ##
    # Given 2 points p1 and p2, and 2 headings for these points,
    # calculate a third point p3 where the extension lines for
    # these points intersect.
    #
    # return point as hash with keys: lat, lng
    def points_intersection(lat1, lng1, h1, lat2, lng2, h2)
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

      { lat: lat3, lng: lng3 }
    end

    ##
    # Given a point p, heading in degrees for this point and a
    # maximum distance in meters, calculate a destination point
    #
    # return point as hash with keys: lat, lng
    def destination_point(lat, lng, h, distance=1500)

      d_angular = angular_distance(distance)
      cos_angular = Math.cos(d_angular)
      sin_angular = Math.sin(d_angular)

      new_lat = Math.asin(Math.sin(lat) * cos_angular +
                          Math.cos(lat) * sin_angular * Math.cos(h))

      new_lng = lng + Math.atan2(Math.sin(h) * sin_angular * Math.cos(lat),
                                 cos_angular - Math.sin(lat) * Math.sin(new_lat))

      { lat: new_lat, lng: new_lng }
    end

    ##
    # Given 3 points p1, p2, p3 calculate a fourth point p4
    # on the line l1 defined from points p1 and p2, such as
    # assuming a second line l2 passing from p4 and p3,
    # is perpendicular to l1
    #
    # return point as hash with keys: lat, lng
    def perpendicular_point(lat1, lng1, lat2, lng2, lat3, lng3)

      minimum_distance = ((lat3 - lat1) * (lat2 - lat1) + (lng3 - lng1) * (lng2 - lng1)) /
        ((lat2 - lat1) * (lat2 - lat1) + (lng2 - lng1) * (lng2 - lng1))

      lat4 = lat1 + minimum_distance * (lat2 - lat1)
      lng4 = lng1 + minimum_distance * (lng2 - lng1)

      { lat: lat4, lng: lng4 }
    end

    ##
    # Find midpoint of line defined by 2 other points
    #
    # return point as hash with keys: lat, lng
    def midpoint(lat1, lng1, lat2, lng2)
      new_lat = (lat1 + lat2) / 2
      new_lng = (lng1 + lng2) / 2

      { lat: new_lat, lng: new_lng }
    end


    ##
    # Adjust a position on the map based on a number of previous reports.
    #
    # This actually returns the coordinates of the Nth part of a line
    # segment.
    # Line segment is defined by lat1/lng1 and lat2/lng2.
    # If no number is given, assume we want the midpoint.
    # This deprecates the <tt>midpoint</tt> function.
    #
    # IMPORTANT
    # The lat1/lng1 must correspond to the incident coordinates.
    #
    # return the new point as hash with keys lat,lng
    def adjust_by_number(lat1, lng1, lat2, lng2, num=2)

      new_lat = lat1 + ((lat2 - lat1) / n)
      new_lng = lng1 + ((lng2 - lng1) / n)

      { lat: new_lat, lng: new_lng }
    end

    ##
    # Calculate angle between 2 lines defined by 3 points
    #
    # return angle in radians
    def angle_between_lines(lat1, lng1, lat2, lng2, lat3, lng3)
      angle1 = Math.atan2(lng1 - lng2, lat1 - lat2)
      angle2 = Math.atan2(lng2 - lng3, lat2 - lat3)

      angle1 - angle2
    end

    # calculate angular distnace using earth's radius
    def angular_distance(distance)
      distance.to_f / R
    end

    ##
    # calculate a bounding rectangle containing the circle defined
    # by `lat`, `lng` and radius `distance`
    # source: http://janmatuschek.de/LatitudeLongitudeBoundingCoordinates
    #
    # return 2 points which represent the rectangle's opposite corners
    def bounding_box(lat, lng, distance)
      d_angular = angular_distance(distance)

      lat_min = lat - d_angular
      lat_max = lat + d_angular

      if lat_min > LAT_MIN and lat_max < LAT_MAX
        d_lng = Math.asin(Math.sin(d_angular) / Math.cos(lat))

        lng_min = lng - d_lng

        if lng_min < LNG_MIN
          lng_min += 2.0 * Math::PI
        end

        lng_max = lng + d_lng

        if lng_max > LNG_MAX
          lng_max -= 2.0 * Math::PI
        end
      else
        lat_min = [lat_min, LAT_MIN].min
        lat_max = [lat_max, LAT_MAX].max
        lng_min = LNG_MIN
        lng_max = LNG_MAX
      end

      { lat_min: lat_min, lng_min: lng_min, lat_max: lat_max, lng_max: lng_max }
    end
  end
end
