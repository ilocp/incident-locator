# Sample login request:
#
# curl -i -X POST "http://127.0.0.1:3000/api/signin" \
#   -H "Content-type: application/json" \
#   -c /tmp/cookie \
#   -d '{"email": "test@example.com", "password": "password-here"}'
#
# Sample login response (+headers):
#
#   HTTP/1.1 200 OK
#   X-Csrf-Token: bTueOzUo2tnkPulT/KEjZAkwBg+ae1nh1asfODb+efM=
#   Content-Type: application/json; charset=utf-8
#   X-Ua-Compatible: IE=Edge
#   Etag: "9d719d3b9aabd413c3603e04e8a3933d"
#   Cache-Control: max-age=0, private, must-revalidate
#   X-Request-Id: 732770b492d9069e83a77b388fbf16c5
#   X-Runtime: 0.106139
#   Server: WEBrick/1.3.1 (Ruby/1.9.3/2013-01-15)
#   Date: Wed, 23 Jan 2013 12:41:18 GMT
#   Content-Length: 35
#   Connection: Keep-Alive
#   Set-Cookie: _incident-locator_session=BAh7CDoMdX [output cut]
#
#   {"msg":"Authentication successful"}

module Api
  class SessionsController < ApplicationController
    respond_to :json

    def create
      user = User.find_by_email(params[:email].downcase)

      if user && user.authenticate(params[:password])
        sign_in user

        # set a crsf token in the response headers for the current session
        # every POST/PUT/DELETE request using the API must supplie this to
        # be considered valid
        response.headers['X-CSRF-Token'] = form_authenticity_token

        respond_with({ msg: 'Authentication successful' }, status: :ok, location: nil)
      else
        respond_with({ msg: 'Invalid email/password combination' }, status: :forbidden,
                     location: nil)
      end
    end
  end
end
