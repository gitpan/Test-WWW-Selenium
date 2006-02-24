package WWW::Selenium::Launcher::UnixDefault;

use strict;
use warnings;
use base qw(WWW::Selenium::Launcher::Pick);

# order is more or less casual (except for Netscape at the end...)
my @browsers = $ENV{SELENIUM_BROWSERS} ? split ' ', $ENV{SELENIUM_BROWSERS} :
               qw(firefox mozilla-firefox mozffremote
		  konqueror mozilla opera netscape);

sub new {
    my( $class ) = @_;

    return $class->SUPER::new( @browsers );
}

1;
