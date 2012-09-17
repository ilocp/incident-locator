module Geoincident

  require 'geoincident/classes'
  require 'geoincident/trig'
  require 'geoincident/version'

  #require 'active_record'

  autoload :ActsAsIncidentData, 'geoincident/acts_as_incident_data'
  autoload :ActsAsIncident,     'geoincident/acts_as_incident'

  def Geoincident::test
    #report = ActiveRecord::Base::Report
    #incident = ActiveRecord::Base::Incident

    #foo = report.first
    #foo
  end

end
