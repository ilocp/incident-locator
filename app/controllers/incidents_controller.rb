class IncidentsController < ApplicationController
  before_filter :signed_in_user

  def index
    @incidents = Incident.all
  end
end
