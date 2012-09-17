module Geoincident
  module ActsAsIncident
    extend ActiveSupport::Concern

    module ClassMethods

      def acts_as_incident args = {}
        puts 'yey incident'
      end

    end

  end
end
