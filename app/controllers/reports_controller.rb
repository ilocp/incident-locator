class ReportsController < ApplicationController
  before_filter :signed_in_user

  def new
    @report = current_user.reports.build
  end

  def create
    @report = current_user.reports.build(params[:report])

    respond_to do |format|
      if @report.save

        # detect possible incidents from this report
        #
        # TODO:
        #   * make it work as a bg job
        #   * make it more generic and configurable
        #
        Geoincident::process(@report)

        flash[:success] = 'Report created successfully'

        format.html { redirect_to current_user }
        format.json { render json: { msg: flash[:success] }, status: :ok }
      else
        format.html { render 'new' }
        format.json { render json: { msg: 'Could not save report' }, status: :bad_request }
      end
    end
  end
end
