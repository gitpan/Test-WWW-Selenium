package WWW::Selenium::Launcher::MacDefault;

use strict;
use warnings;
use base qw(WWW::Selenium::Launcher::Base);

sub new {
    my( $class ) = @_;

    return $class->SUPER::new( 'open' );
}

1;
