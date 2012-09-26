module IncidentsHelper

  private

  MAP_OPTIONS = { map_options: { type: 'SATELLITE', auto_adjust: true } }

  # create the appropriate JSON required for gmaps4rails circles
  def json_circles(data)
    json_array = []

    data.each do |record|
      json_array << { lat: record.latitude, lng: record.longitude, radius: record.radius }
    end

    json_array.to_json
  end

  # create the appropriate JSON required for gmaps4rails markers
  def json_markers(data)
    json_array = []

    data.each do |record|
      json_array << { lat: record.latitude, lng: record.longitude }
    end

    json_array.to_json
  end

  # sets the appropriate settings+data format for displaying all incidents with
  # gmaps4rails
  def format_incidents(data)
    map_data = MAP_OPTIONS

    # set viewport when we don't have data
    if data.empty?
      no_data_options = { center_latitude: 47.635784, center_longitude: 17.050781,
                          zoom: 4, auto_adjust: false }

      map_data[:map_options].merge!(no_data_options)
      return map_data
    end

    # show circles and markers for incidents
    map_data[:circles] = { data: json_circles(data) }
    map_data[:markers] = { data: json_markers(data) }
    map_data
  end

end
