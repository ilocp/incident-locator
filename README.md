Incident Locator
================

[![Code Climate][ccbadge]][ccrepo]
[![development][cidev]][cirepo]
[![Dependency Status][gembadge]][gemrepo]
[![Test Coverage][coverbadge]][coverrepo]

About
-----

Source code for an Incident Identification service.
Pilot implementation using information gathered from mobile devices.
Part of my thesis.

* Source code: https://github.com/ilocp/incident-locator
* Android client: https://github.com/ilocp/incident-locator-android


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
View the [API examples here](https://github.com/ilocp/incident-locator/wiki/API).

License
-------
Under the BSD 3-Clause License. See `LICENSE`.


[ccrepo]: https://codeclimate.com/github/ilocp/incident-locator
[ccbadge]: https://codeclimate.com/github/ilocp/incident-locator.png
[cidev]: https://travis-ci.org/ilocp/incident-locator.png
[cirepo]: http://travis-ci.org/ilocp/incident-locator
[gemrepo]: https://gemnasium.com/ilocp/incident-locator
[gembadge]: https://gemnasium.com/ilocp/incident-locator.png
[coverrepo]: https://coveralls.io/r/ilocp/incident-locator
[coverbadge]: https://coveralls.io/repos/ilocp/incident-locator/badge.png?branch=development

