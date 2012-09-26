module IncidentsHelper

  private

  # create the appropriate JSON required for gmaps4rails circles
  def json_circle(data)
    json_array = []

    data.each do |record|
      json_array << { lat: record.latitude, lng: record.longitude, radius: record.radius }
    end

    json_array.to_json
  end
end
