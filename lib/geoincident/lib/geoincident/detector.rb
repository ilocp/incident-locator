module Geoincident

  require 'geoincident/constants'
  require 'geoincident/helper/classes'
  require 'geoincident/helper/trig'

  class Detector
    # TODO: don't hardcode models

    def initialize(reference_report)
      @reference_report = reference_report
    end

    def belongs_to_incident?
      raise NotImplementedError
    end

    def attach_to_incident
      raise NotImplementedError
    end

    def detect_new_incident
      orphans = get_orphan_reports

      # TODO try to remove location object requirement
      p1 = Location.new(@reference_report.latitude, @reference_report.longitude,
                        @reference_report.heading)

      incident = nil
      orphans.each do |report|
        # iterate each report not assigned to an incident
        # and calculate the intersections

        # TODO: modify trig code to avoid creating location objects
        # Note: this is test code that may blow up
        if report.id == @reference_report.id
          next
        end

        p2 = Location.new(report.latitude, report.longitude, report.heading)

        cross_point = Trig.points_intersection(p1, p2)

        if cross_point.nil?
          next
        end

        # calculate distances
        d1 = Trig.location_distance(p1, cross_point)
        d2 = Trig.location_distance(p2, cross_point)

        # if distances are inside visibility radius we have a new incident
        if d1 <= VISIBILITY_RADIUS and d2 <= VISIBILITY_RADIUS

          # set a default radius for the incident
          incident_data = { latitude: cross_point.lat, longitude: cross_point.lng,
                            radius: INCIDENT_RADIUS }
          incident = Incident.new(incident_data)
          incident.save

          # attach these reports to the new incident
          # TODO add some error checking here
          @reference_report.incident_id = incident.id
          @reference_report.save
          report.incident_id = incident.id
          report.save

          # nothing more to do, break the loop
          # we nedd to call another method after that to search for
          # other orphan reports that may belong in this incident
          break

        end
      end

      incident

    end


    private

    def get_orphan_reports(date_range=nil)
      # Return all orphan reports, namely all records with nil incident_id
      # by default all reports created/updated 2 days ago are considered
      date_range ||= 2.days.ago...Time.now
      Report.where(incident_id: nil, updated_at: date_range)
    end
  end
end
