module Geoincident
  # constant definitions

  VISIBILITY_RADIUS = 1500
  INCIDENT_RADIUS = 3000

  # radius used to calculate the angular radius of a query circle
  # the Bounding Rectangle will completely contain this circle
  QUERY_CIRCLE_RADIUS = 80000

  # report weight
  # this number will give approximately a 100m deviation
  REPORT_WEIGHT = 0.00005
end
