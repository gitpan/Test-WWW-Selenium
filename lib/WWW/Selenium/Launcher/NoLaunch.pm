package WWW::Selenium::Launcher::NoLaunch;

use strict;
use warnings;

sub new { bless {}, $_[0] }

sub launch {
    my( $self, $url ) = @_;

#    print $url;
}

sub close { }

1;
