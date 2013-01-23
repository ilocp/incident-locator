Incident Locator [![Code Climate][ccbadge]][ccrepo] [![development][cidev]][cirepo] [![master][cimaster]][cirepo]
================

About
-----

Source code for an Incident Identification service.
Pilot implementation using information gathered from mobile devices.
Part of my thesis.

* Source code: https://github.com/tlatsas/incident-locator
* Android client: https://github.com/tlatsas/incident-locator-android


Dev installation
----------------

Clone the repository and run:

    $ bundle install --without production

this will install all required gems. If you want to isolate your gem installation
create a folder `bundle` inside vendor and tell bundler to install all gems to that
location:

    $ mkdir -p vendor/bundle
    $ bundle install --path vendor/bundle --without production

Then, create and seed the database:

    $ bundle exec rake db:create
    $ bundle exec rake db:migrate
    $ bundle exec rake db:seed


Running the tests
-----------------

This project uses rspec for all the tests. To create the test database for
the first time run:

    $ bundle exec rake db:migrate db:test:prepare db:seed

and then run the tests:

    $ bundle exec rspec spec/

Spork and guard are also configured. To run guard (loads spork automatically) run:

    $ bundle exec guard

if you want to run some rspec test with the spork instance that already runs on
guard run:

    $ bundle exec rspec spec/ --drb


API
---

The service exposes a minimal REST API for the clients to utilize.
This is a simple documentation that acts mostly as a reminder.

### Login

Using curl to login:

    curl -i -X POST "http://127.0.0.1:3000/api/signin" \
      -H "Content-type: application/json" \
      -c /tmp/cookie \
      -d '{"email": "test@example.com", "password": "password-here"}'

Sample login response (+headers):

    HTTP/1.1 200 OK
    X-Csrf-Token: bTueOzUo2tnkPulT/KEjZAkwBg+ae1nh1asfODb+efM=
    Content-Type: application/json; charset=utf-8
    X-Ua-Compatible: IE=Edge
    Etag: "9d719d3b9aabd413c3603e04e8a3933d"
    Cache-Control: max-age=0, private, must-revalidate
    X-Request-Id: 732770b492d9069e83a77b388fbf16c5
    X-Runtime: 0.106139
    Server: WEBrick/1.3.1 (Ruby/1.9.3/2013-01-15)
    Date: Wed, 23 Jan 2013 12:41:18 GMT
    Content-Length: 35
    Connection: Keep-Alive
    Set-Cookie: _incident-locator_session=BAh7CDoMdX [output cut]

    {"msg":"Authentication successful"}

The http status code can be used to determine if login was successful.
On failed login expect a forbidden `403` status code.

Sample failed login response:

    {"msg":"Invalid email/password combination"}


### User info

Using curl to get basic user info:

    curl -i -X GET "http://127.0.0.1:3000/api/profile" \
        -H "Content-type: application/json" \
        -b /tmp/cookie \
        -H "X-Csrf-Token: zZJChBamIhboyCv0Zyr7ygEFGJYERUbcCMfpOSS6WNo="

Note that the Csrf token, extracted from the login response must be used
at the request headers. Sample response:

    {"email":"test@example.com","name":"testuser"}


### Send incident data

Using curl to send incident data:

    curl -i -X POST "http://127.0.0.1:3000/api/report" \
        -H "Content-type: application/json" \
        -b /tmp/cookie \
        -H "X-Csrf-Token: zZJChBamIhboyCv0Zyr7ygEFGJYERUbcCMfpOSS6WNo=" \
        -d'{"latitude": 14.123456, "longitude": 11.123456, "heading": 45}'

Note that the Csrf token, extracted from the login response must be used
at the request headers. Sample response:

    {"msg":"Report created successfully"}

The http status code can be used to determine if the report request was successful.
On a failed request expect a bad request `400` status code.

License
-------
Under the BSD 3-Clause License. See `LICENSE`.


[ccrepo]: https://codeclimate.com/github/tlatsas/incident-locator
[ccbadge]: https://codeclimate.com/badge.png
[cimaster]: https://secure.travis-ci.org/tlatsas/incident-locator.png?branch=master
[cidev]: https://secure.travis-ci.org/tlatsas/incident-locator.png?branch=development
[cirepo]: http://travis-ci.org/tlatsas/incident-locator
