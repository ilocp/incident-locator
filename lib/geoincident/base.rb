module Geoincident

  require 'geoincident/classes'
  require 'geoincident/trig'

  autoload :ActsAsIncidentData, 'geoincident/acts_as_incident_data'
  autoload :ActsAsIncident,     'geoincident/acts_as_incident'
end
