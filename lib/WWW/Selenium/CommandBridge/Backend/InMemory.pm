package WWW::Selenium::CommandBridge::Backend::InMemory;
use strict;
use warnings;
use base 'WWW::Selenium::CommandBridge::Backend';

my $self; # singleton

sub new {
    my ($class, %opts) = @_;
    return $self if $self;
    $self = \%opts;
    bless $self, $class;
    return $self;
}

sub reset           { delete $_[0]->{cmd}; delete $_[0]->{result} }
sub set_timeout     { $_[0]->{timeout} = $_[1] }
sub queue_command   { $_[0]->{cmd} = $_[1] }
sub get_command     { delete $_[0]->{cmd} }
sub result          { $_[0]->{result} = $_[1] }
sub get_result      { delete $_[0]->{result} || 'OK' }
sub finished        { $_[0]->{finished}++ }

1;
