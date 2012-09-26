include IncidentsHelper

class IncidentsController < ApplicationController
  before_filter :signed_in_user

  def index
    @incidents = Incident.all
  end

  def map
    @incidents = json_circle(Incident.all)
  end
end
