module Geoincident

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

        cross_point = Geoincident::points_intersection(p1, p2)

        if cross_point.nil?
          next
        end

        # calculate distances
        d1 = Geoincident::location_distance(p1, cross_point)
        d2 = Geoincident::location_distance(p2, cross_point)

        # if distances are inside visibility radius we have a new incident
        v_distance = 1500
        if d1 <= v_distance and d2 <= v_distance
          # set a default radius for the incident
          # TODO make configurable
          incident_data = { latitude: cross_point.lat, longitude: cross_point.lng, radius: 3000 }
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

    def get_orphan_reports
      # Maybe use time constraints to limit reports?
      # Eg something like:
      #   Report.where(incident_id: nil, created_at: 2.days.ago...Time.now)

      Report.where(:incident_id => nil)

    end
  end
end
