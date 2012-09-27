class StaticPagesController < ApplicationController
  def home
    # well we cheat a bit here, because that is not entirely "static"

    # for the time now don't show any incidents, just a map
    @incidents_data = format_incidents([])
  end
end
