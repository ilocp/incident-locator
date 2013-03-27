# Using curl to send incident data:
#
#     curl -i -X POST "http://127.0.0.1:3000/api/report" \
#         -H "Content-type: application/json" \
#         -b /tmp/cookie \
#         -H "X-Csrf-Token: zZJChBamIhboyCv0Zyr7ygEFGJYERUbcCMfpOSS6WNo=" \
#         -d'{"latitude": 14.123456, "longitude": 11.123456, "heading": 45}'
#
# Note that the Csrf token, extracted from the login response must be used at
# the request headers. Sample response:
#
#     {"msg":"Report created successfully"}
#
# The http status code can be used to determine if the report request was successful.
# On a failed request expect a bad request `400` status code.

module Api
  class ReportsController < ApplicationController
    before_filter :signed_in_user
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
