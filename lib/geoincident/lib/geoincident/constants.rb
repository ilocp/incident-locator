module Geoincident
  # constant definitions

  VISIBILITY_RADIUS = 1500
  INCIDENT_RADIUS = 3000

  # radius used to calculate the angular radius of a query circle
  # the Bounding Rectangle will completely contain this circle
  QUERY_CIRCLE_RADIUS = 80000

  # when reports of an incident reach the following threshold we
  # switch from the number-based to the weight-based algorithm
  REPORT_THRESHOLD = 50

  # report weight
  # this number will give approximately a 100m deviation
  REPORT_WEIGHT = 0.00005

  # distance used when calculating the average location
  # if the generated incident is <= AVG_DISTANCE then it
  # can be used to calculate the average location of the
  # actual incident
  AVG_DISTANCE = 3000
end
