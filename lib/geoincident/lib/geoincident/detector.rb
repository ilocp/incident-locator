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

      incident = nil
      orphans.each do |report|
        # iterate each report not assigned to an incident
        # and calculate the intersections

        if report.id == @reference_report.id
          next
        end

        cross_point = Trig.points_intersection(@reference_report.latitude.to_rad,
                                               @reference_report.longitude.to_rad,
                                               @reference_report.heading.to_rad,
                                               report.latitude.to_rad,
                                               report.longitude.to_rad,
                                               report.heading.to_rad)

        if cross_point.nil?
          next
        end

        # calculate distances
        d1 = Trig.location_distance(@reference_point.latitude.to_rad,
                                    @reference_point.longitude.to_rad,
                                    cross_point[:lat], cross_point[:lng])

        d2 = Trig.location_distance(report.latitude.to_rad,
                                    report.longitude.to_rad,
                                    cross_point[:lat], cross_point[:lng])

        # if distances are inside visibility radius we have a new incident
        if d1 <= VISIBILITY_RADIUS and d2 <= VISIBILITY_RADIUS

          # set a default radius for the incident
          incident_data = { latitude: cross_point[:lat].to_degrees,
                            longitude: cross_point[:lng].to_degrees,
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
