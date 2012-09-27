class IncidentsController < ApplicationController
  before_filter :signed_in_user

  def index
    @incidents = Incident.all
  end

  def map
    @incidents_data = format_incidents(Incident.all)
  end
end
