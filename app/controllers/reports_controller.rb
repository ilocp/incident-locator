class ReportsController < ApplicationController
  before_filter :signed_in_user

  def new
    @report = current_user.reports.build
  end

  def create
    @report = current_user.reports.build(params[:report])
    if @report.save

      # detect possible incidents from this report
      #
      # TODO:
      #   * make it work as a bg job
      #   * make it more generic and configurable
      #
      Geoincident::process(@report)

      flash[:success] = 'Report created successfully'
      redirect_to current_user
    else
      render 'new'
    end
  end
end
