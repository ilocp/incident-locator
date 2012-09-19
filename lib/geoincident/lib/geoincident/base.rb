module Geoincident

  require 'geoincident/version'
  require 'geoincident/detector'

  # do we really need this behaviour?
  # maybe use it to get model configuration later (if I get it work)
  #
  #autoload :ActsAsIncidentData, 'geoincident/acts_as_incident_data'
  #autoload :ActsAsIncident,     'geoincident/acts_as_incident'

  def Geoincident::process(report)
    d = Detector.new(report)

    # Initial functionality: just test for new reports
    # we actually need somethins more elaborate than this
    d.detect_new_incident
  end

end
