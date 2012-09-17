module Geoincident
  module ActsAsIncidentData
    extend ActiveSupport::Concern

    module ClassMethods

      def acts_as_incident_data options = {}

        define_method "geoincident_options" do
          {
            :lat_column => options[:lat] || 'latitude',
            :lng_column => options[:lng] || 'longitude',
            :incident_id_column => options[:incident_id] || 'incident_id'
          }
        end
      end

    end

  end
end

