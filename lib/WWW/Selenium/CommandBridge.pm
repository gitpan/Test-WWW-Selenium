package WWW::Selenium::CommandBridge;
use warnings;
use strict;
use Carp qw(croak);
use WWW::Selenium::Command;

sub new {
    my ($class, %opts) = @_;
    my $self = { };
    bless $self, $class;

    # default to a file based backend
    my $backend = $opts{backend} || 'File';
    my $backend_mod = "WWW::Selenium::CommandBridge::Backend::$backend";
    eval "require $backend_mod";
    die "Cannot load the '$backend' CommandBridge backend: $@" if $@;
    $self->{backend} = $backend_mod->new;
    $self->set_timeout(15);

    return $self;
}

# commands for the test script

sub reset { $_[0]->{backend}->reset }

sub set_timeout {
    my ($self, $timeout) = @_;
    $self->{timeout} = $timeout;
    $self->{backend}->set_timeout($timeout);
}

sub add {
    my ($self, @details) = @_;
    my $cmd = WWW::Selenium::Command->new(@details);

    $self->{backend}->queue_command($cmd);
}

sub get_result {
    my ($self) = @_;

    my $result;
    eval {
        $result = $self->{backend}->get_result;
    };
    croak "Error fetching result: $@" if $@;
    return $result;
}

sub finished {
    my ($self) = @_;

    $self->{backend}->finished;
}

# commands for the browser

sub get_next_command {
    my ($self, $prev_result, $nonblocking) = @_;

    $self->{backend}->result($prev_result) if $prev_result;
    return $self->{backend}->get_command($nonblocking);
}

1;
