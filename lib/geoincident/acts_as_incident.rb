module Geoincident
  module ActsAsIncident
    extend ActiveSupport::Concern

    module ClassMethods

      def acts_as_incident options = {}

        define_method "geoincident_options" do
          {
            :lat_column => options[:lat] || 'latitude',
            :lng_column => options[:lng] || 'longitude'
          }
        end
      end

    end

  end
end
