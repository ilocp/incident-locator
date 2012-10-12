module Geoincident

  require 'geoincident/constants'
  require 'geoincident/helper/classes'
  require 'geoincident/helper/trig'

  class Detector
    # TODO: don't hardcode models

    def detect_new_incident(reference_report)
      orphans = get_orphan_reports(reference_report)

      incident = nil
      orphans.each do |report|
        # iterate each report not assigned to an incident
        # and calculate the intersections

        if report.id == reference_report.id
          next
        end

        cross_point = Trig.points_intersection(reference_report.latitude.to_rad,
                                               reference_report.longitude.to_rad,
                                               reference_report.heading.to_rad,
                                               report.latitude.to_rad,
                                               report.longitude.to_rad,
                                               report.heading.to_rad)

        if cross_point.nil?
          next
        end

        # calculate distances
        d1 = Trig.location_distance(reference_report.latitude.to_rad,
                                    reference_report.longitude.to_rad,
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

          with_incident_logger do
            incident = Incident.new(incident_data)
            incident.save!
          end

          Geoincident.logger.debug "Reports with IDs #{reference_report.id} and #{report.id} "\
                                   "created new incident with data: #{incident_data.to_s}"

          # attach these reports to the new incident
          attach_to_incident(reference_report, incident)
          attach_to_incident(report, incident)

          # nothing more to do, break the loop
          # we nedd to call another method after that to search for
          # other orphan reports that may belong in this incident
          break

        end
      end

      incident
    end

    # Search all active incidents and determine if given
    # report should belong to it
    def scan_incidents(report)
      active_incidents = get_active_incidents(report)

      active_incidents.each do |incident|
        unless belongs_to_incident?(report, incident)
          next
        end

        attach_to_incident(report, incident)

        if can_adjust_incident_position?(report, incident)
          adjust_incident_position(report, incident)
        end

        return true
      end

      false
    end

    # Search all orphan reports and determine if any of them
    # should be attached to the given incident
    def scan_reports(incident)
      orphan_reports = get_orphan_reports(incident)

      orphan_reports.each do |report|
        unless belongs_to_incident?(report, incident)
          next
        end

        attach_to_incident(report, incident)

        if can_adjust_incident_position?(report, incident)
          adjust_incident_position(report, incident)
        end
      end
    end

    private

    # Return all orphan reports, namely all records with nil incident_id
    # by default all reports created/updated 2 days ago are considered
    def get_orphan_reports(location, date_range=nil, query_radius=nil)
      # FIXME see if 2 days is too old
      date_range ||= 2.days.ago...Time.now
      query_radius ||= Geoincident::QUERY_CIRCLE_RADIUS

      # get coordinate ranges which include our candidate reports
      lat_range, lng_range = query_ranges(location, query_radius)

      Report.where(incident_id: nil, updated_at: date_range,
                   latitude: lat_range, longitude: lng_range)
    end

    # Return all incidents considered as active
    def get_active_incidents(location, date_range=nil, query_radius=nil)
      # FIXME see if 2 days is too old
      date_range ||= 2.days.ago...Time.now
      query_radius ||= Geoincident::QUERY_CIRCLE_RADIUS

      # get coordinate ranges which include our candidate reports
      lat_range, lng_range = query_ranges(location, query_radius)

      Incident.where(updated_at: date_range, latitude: lat_range,
                     longitude: lng_range)
    end

    # return the number of reports assigned to the incident with given id
    def report_count(incident_id)
      Report.where(incident_id: incident_id).count
    end

    # use the bounding box technique to return query limits for coordinates
    # returns two range objects one for latitude and one for longitude
    # +location+ must respond to latitude and longitude methods
    # +radius+ must be in meters
    def query_ranges(location, radius)
      box = Trig.bounding_box(location.latitude.to_rad,
                              location.longitude.to_rad,
                              radius)

      Geoincident.logger.debug "Calculated bounding box with coordinates: "\
                               "min: [#{box[:lat_min].to_degrees} / #{box[:lng_min].to_degrees}] "\
                               "max: [#{box[:lat_max].to_degrees} / #{box[:lng_max].to_degrees}]"

      lat_range = box[:lat_min].to_degrees..box[:lat_max].to_degrees
      lng_range = box[:lng_min].to_degrees..box[:lng_max].to_degrees

      [lat_range, lng_range]
    end

    # Check if given report should belong to incident
    def belongs_to_incident?(report, incident)
      # check if report is within incident radius
      distance = Trig.location_distance(report.latitude.to_rad,
                                        report.longitude.to_rad,
                                        incident.latitude.to_rad,
                                        incident.longitude.to_rad)

      if distance > incident.radius
        return false
      end

      true
    end

    def can_adjust_incident_position?(report, incident)
      # avoid duplicate radian conversion
      r_lat = report.latitude.to_rad
      r_lng = report.longitude.to_rad

      # calculate a 3rd point using the report and radius
      dest = Trig.destination_point(r_lat, r_lng, report.heading.to_rad,
                                    VISIBILITY_RADIUS)

      angle = Trig.angle_between_lines(incident.latitude.to_rad,
                                       incident.longitude.to_rad,
                                       r_lat, r_lng,
                                       dest[:lat], dest[:lng])

      # we can adjust incident position only if angle <= 90
      if angle.to_degrees.abs > 90
        return false
      end

      true
    end

    # attach report to incident
    def attach_to_incident(report, incident)
      with_report_logger do
        report.incident_id = incident.id
        report.save!
        Geoincident.logger.debug "Report #{report.id} attached to incident #{incident.id}"
      end
    end

    # use a report to adjust (improve) the location of an incident
    # this function does not perform any point validity checks
    # caller must decide if report is appropriate to improve the
    # incident's location
    def adjust_incident_location(report, incident)
      # avoid duplicate radian calculations
      r_lat = report.latitude.to_rad
      r_lng = report.longitude.to_rad
      r_h = report.heading.to_rad

      i_lat = incident.latitude.to_rad
      i_lng = incident.longitude.to_rad

      # calculate destination point of report in order to obtain a
      # virtual line
      dest = Trig.destination_point(r_lat, r_lng, r_h, VISIBILITY_RADIUS)

      # calculate the point where the previous virtual line
      # is perpendicular with a virtual line passing from the
      # incident location
      p_point = Trig.perpendicular_point(r_lat, r_lng,
                                         dest[:lat], dest[:lng],
                                         i_lat, i_lng)

      # calculate new position
      # If we don't have many reports use the number-based algorithm
      # If we have many reports we need only small adjustments so we
      # use the weight-based algorithm
      reports_count = report_count(incident.id)

      if reports_count > REPORT_THRESHOLD
        new_position = adjust_by_weight(incident, p_point)
      else
        new_position = adjust_by_number(incident, p_point, reports_count)
      end

      # update position
      incident.latitude = new_position[:lat].to_degrees
      incident.longitude = new_position[:lng].to_degrees

      with_incident_logger { incident.save! }

      Geoincident.logger.debug "Incident #{incident.id} position adjust by report #{report.id} "\
                               "at lat: #{incident.latitude} / lng: #{incident.longitude}"
    end

    # Calculate new position based on the number of previous reports
    #
    # Each subsequent report contributes less from the previous report.
    # If we have 10 reports, we separate the virtual line  segment
    # between the incident (i) and the perpendicular point (p) in 9
    # equal parts. We choose the closest to the incident part as our
    # new incident position (n).
    #
    #  | -- * -- * -- * -- * -- * -- * -- * -- * -- |
    #  i    n                                       p
    #
    #
    # Parameters:
    # * incident object which responds in latitude/longitude
    # * hash which contains lat/lng in rads to act as the second point
    # of the line segment
    #
    # Return hash with new position in rads
    def adjust_by_number(incident, point, reports_count)
      Trig.n_segment_coordinates(incident.latitude.to_rad,
                                 incident.longitude.to_rad,
                                 point[:lat], point[:lng],
                                 reports_count - 1)
    end

    # Calculate new position based on a fixed weight
    #
    # What we actually do here is adding a small fixed
    # percent of the line segment length to the incident
    # coordinates.
    #
    # Parameters:
    # * incident object which responds in latitude/longitude
    # * hash which contains lat/lng in rads to act as the second point
    # of the line segment
    # * Optional weight number, if none passed the REPORT_WEIGHT
    # constant will be used
    #
    # Return hash with new position in rads
    def adjust_by_weight(incident, point, weight=nil)
      weight ||= REPORT_WEIGHT

      new_lat = incident.latitude.to_rad + ( point[:lat] * weight )
      new_lng = incident.longitude.to_rad + ( point[:lng] * weight )

      { lat: new_lat, lng: new_lng }
    end

    # use when creating/updating report records
    def with_report_logger
      begin
        yield
      rescue ActiveRecord::RecordInvalid => invalid
        Geoincident.logger.error "Could not set incident id for report"
        Geoincident.logger.error invalid.record.errors.messages.to_s
      end
    end

    # use when creating/updating incident records
    def with_incident_logger
      begin
        yield
      rescue ActiveRecord::RecordInvalid => invalid
        Geoincident.logger.error "Could not create/update incident record"
        Geoincident.logger.error invalid.record.errors.messages.to_s
      end
    end

  end
end
