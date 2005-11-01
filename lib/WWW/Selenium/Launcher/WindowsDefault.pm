package WWW::Selenium::Launcher::WindowsDefault;

use strict;
use warnings;
use base qw(WWW::Selenium::Launcher::Base);

sub new {
    my( $class ) = @_;

    return $class->SUPER::new( 'cmd /c start' );
}

1;
