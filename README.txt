WWW::Selenium is a per driver for the Selenium Web testing
framework.

Copyright (c) 2005 Mattia Barbon.
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
