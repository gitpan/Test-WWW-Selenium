package WWW::Selenium::Launcher::Default;

use strict;

my $package = $^O eq 'MSWin32' ? 'WindowsDefault' :
              $^O eq 'darwin'  ? 'MacDefault' :
                                 'UnixDefault';

require "WWW/Selenium/Launcher/$package.pm";
die $@ if $@;

our @ISA = "WWW::Selenium::Launcher::$package";

1;
