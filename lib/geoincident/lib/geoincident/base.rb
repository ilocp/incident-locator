module Geoincident

  require 'geoincident/logger'
  require 'geoincident/version'
  require 'geoincident/engines/tracking'

  extend self

  # do we really need this behaviour?
  # maybe use it to get model configuration later (if I get it work)
  #
  #autoload :ActsAsIncidentData, 'geoincident/acts_as_incident_data'
  #autoload :ActsAsIncident,     'geoincident/acts_as_incident'

  def run_tracking_incident_engine(report)
    detector = TrackingDetector.new

    # check if we can attach this report to an existing incident
    existing_incident = detector.scan_incidents(report)

    # we could not find incident to attach our report
    # try to create a new one using other reports from
    # the database
    if existing_incident.nil?
      new_incident = detector.detect_new_incident(report)

      # scan other orphan reports as they may
      # belong to the newly-created incident
      unless new_incident.nil?
        detector.scan_reports(new_incident)
        return new_incident
      end
    end

    existing_incident
  end

  def run_static_incident_engine(incident)
    nil
  end

  def Geoincident::process(report)
    Geoincident.logger.push_tags(["DETECTION"])
    Geoincident.logger.info "Incident detection process started on #{Time.now}"

    incident = run_tracking_incident_engine report
    unless incident.nil?
      Geoincident.logger.info "Calculating average location #{Time.now}"
      run_static_incident_engine incident
    end

    Geoincident.logger.info "Incident detection process ended on #{Time.now}"
    Geoincident.logger.pop_tags
  end

end
