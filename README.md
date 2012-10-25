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

    $ bundle exec rspect spec/ --drb


License
-------
Under the BSD 3-Clause License. See `LICENSE`.


[ccrepo]: https://codeclimate.com/github/tlatsas/incident-locator
[ccbadge]: https://codeclimate.com/badge.png
[cimaster]: https://secure.travis-ci.org/tlatsas/incident-locator.png?branch=master
[cidev]: https://secure.travis-ci.org/tlatsas/incident-locator.png?branch=development
[cirepo]: http://travis-ci.org/tlatsas/incident-locator
