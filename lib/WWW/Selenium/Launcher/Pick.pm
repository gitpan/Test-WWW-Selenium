package WWW::Selenium::Launcher::Pick;

use strict;
use warnings;
use base qw(WWW::Selenium::Launcher::Base);
use File::Spec;

sub new {
    my( $class, @commands ) = @_;

    foreach my $command ( @commands ) {
        foreach my $dir ( File::Spec->path ) {
            my $try = File::Spec->catfile( $dir, $command );

            if( -f $try && -x $try ) {
                return $class->SUPER::new( $try );
            }
        }
    }

    die 'Could not find a suitable browser';
}

1;
