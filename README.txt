WWW::Selenium is a Perl driver for the Selenium Web testing
framework.

Selenium (http://selenium.openqa.org/) is a test tool for web
applications. Selenium tests run directly in a browser, just as real
users do. And they run in Internet Explorer, Mozilla and Firefox on
Windows, Linux, and Macintosh. Selenium in not meant for unit testing
but is invluable for functional/acceptance testing of applications
relying on JavaScript.

Copyright (c) 2005, 2006 Mattia Barbon <mbarbon@cpan.org>.
This package is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

Please notice that Selenium comes with its own license.

To install:

    perl Build.PL
    perl Build
    perl Build test
    perl Build install

For WWW::Selenium to be useful you need a Selenium 'server'; you can
either download the server from the Selenium web site (it is written in
Python/Perl and a Windows binary is provided) or use the one included
with WWW::Selenium (see script/selenium_server.pl).
