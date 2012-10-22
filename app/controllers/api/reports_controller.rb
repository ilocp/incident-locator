module Api
  class ReportsController < ApplicationController
    before_filter :signed_in_user
    #skip_before_filter :verify_authenticity_token
    respond_to :json

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

        respond_with({ msg: 'Report created successfully' }, status: :created,
                     location: nil)
      else
        respond_with({ msg: 'Could not save report' }, status: :bad_request,
                     location: nil)
      end
    end
  end
end
