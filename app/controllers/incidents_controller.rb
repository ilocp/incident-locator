class IncidentsController < ApplicationController
  before_filter :signed_in_user

  def index
    @incidents = Incident.all
  end

  def map
    @incidents = Incident.all.to_gmaps4rails
  end
end
