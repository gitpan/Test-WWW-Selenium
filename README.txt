WWW::Selenium is a Perl driver for the Selenium Web testing
framework.

Selenium (http://selenium.openqa.org/) is a test tool for web
applications. Selenium tests run directly in a browser, just as real
users do. And they run in Internet Explorer, Mozilla and Firefox on
Windows, Linux, and Macintosh. Selenium in not meant for unit testing
but is invluable for functional/acceptance testing of applications
relying on JavaScript.

Copyright (c) 2006 Luke Closs <lukec@cpan.org>.
Copyright (c) 2005, 2006 Mattia Barbon <mbarbon@cpan.org>.
This package is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

Please notice that Selenium comes with its own license.

To install:

    perl Makefile.PL
    make
    make test
    make install


Using WWW::Selenium to Test Stuff

To use WWW::Selenium, you'll need to install Selenium on your web server.
There are two ways you could do this.  You could fetch the Selenium tarball 
(from http://openqa.org/selenium) and then extract it to some web visible
location (/selenium, say).  Alternately, you could install the 
Alien::Selenium perl package which bundles a stripped down copy of Selenium.
Alien::Selenium should bundle a utility called selenium-install which
can install the stripped down Selenium to a specified location.

After you have Selenium installed on your webserver, you will need to setup
the Selenium Server CGI driver.  An example driver is included in this 
package (scripts/driver.cgi).  Move this file to the same place you installed 
Selenium, so that it will be visible as /selenium/driver.

At this point, you're ready to go!  Look at the included script/passenger 
script to see an example of how your test script should look.


WWW::Selenium Architecture

There are several objects you, the user of WWW::Selenium, should be aware of.
They are:

- Test::WWW::Selenium
    Your test script will create one of these objects, and use it for testing.
    This class wraps all of the Selenium commands with _ok, _is, _like ...

- WWW::Selenium
    The Test::WWW::Selenium class subclasses this one.  This class contains
    all of the Selenium commands (open, verifyText, ...) and will also
    launch and kill browsers.

- WWW::Selenium::Driver
    Your Selenium CGI driver will uses this class to control communication with
    the test script.  The CGI driver is used by your web browser to fetch
    commands to execute and to report results.

- WWW::Selenium::CommandBridge
    This class handles the communication between your perl test script and the
    CGI driver.  There may be several different implementations of the
    CommandBridge which could be useful in different environments.
