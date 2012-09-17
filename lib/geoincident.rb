#
# Incident recognition based on geospatial points
#

module Geoincident
  require 'rails'
  require 'geoincident/base'

  class Railtie < Rails::Railtie

    initializer "include acts_as_*" do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :include, Geoincident::ActsAsIncidentData
        ActiveRecord::Base.send :include, Geoincident::ActsAsIncident
      end
    end

  end
end
