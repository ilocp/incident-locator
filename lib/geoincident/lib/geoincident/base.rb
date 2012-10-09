module Geoincident

  require 'geoincident/logger'
  require 'geoincident/version'
  require 'geoincident/detector'

  # do we really need this behaviour?
  # maybe use it to get model configuration later (if I get it work)
  #
  #autoload :ActsAsIncidentData, 'geoincident/acts_as_incident_data'
  #autoload :ActsAsIncident,     'geoincident/acts_as_incident'

  def Geoincident::process(report)
    Geoincident.logger.debug "Incident detection process started on #{Time.now}"

    detector = Detector.new

    # check if we can attach this report to an existing incident
    found = detector.scan_incidents(report)

    # we could not find incident to attach our report
    # try to create a new one using other reports from
    # the database
    unless found
      new_incident = detector.detect_new_incident(report)

      # scan other orphan reports as they may
      # belong to the newly-created incident
      unless new_incident.nil?
        detector.scan_reports(new_incident)
      end
    end
    Geoincident.logger.debug "Incident detection process ended on #{Time.now}"
  end

end
