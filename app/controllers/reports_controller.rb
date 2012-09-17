class ReportsController < ApplicationController
  before_filter :signed_in_user

  def new
    @report = current_user.reports.build
    #@foo = Geoincident::test
  end

  def create
    @report = current_user.reports.build(params[:report])
    if @report.save
      flash[:success] = 'Report created successfully'
      redirect_to current_user
    else
      render 'new'
    end
  end
end
