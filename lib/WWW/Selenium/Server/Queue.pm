package WWW::Selenium::Server::Queue;

use strict;
use warnings;

use POE;

sub new {
    my $class = shift;
    my $self = bless { queue    => [],
                       signals  => [],
                      }, $class;

    return $self;
}

sub enqueue {
    my( $self, $elt ) = @_;

    if( @{$self->{signals}} ) {
        my $signal = shift @{$self->{signals}};

        $signal->( $elt );
    } else {
        push @{$self->{queue}}, $elt;
    }
}

sub dequeue {
    my( $self, $signal ) = @_;

    if( @{$self->{queue}} ) {
        my $elt = shift @{$self->{queue}};

        $signal->( $elt );
    } else {
        push @{$self->{signals}}, $signal;
    }
}

my $cmd_q = WWW::Selenium::Server::Queue->new;
my $rsp_q = WWW::Selenium::Server::Queue->new;

sub enqueue_command { $cmd_q->enqueue( $_[1] ) }
sub dequeue_command { $cmd_q->dequeue( $_[1] ) }
sub enqueue_response { $rsp_q->enqueue( $_[1] ) }
sub dequeue_response { $rsp_q->dequeue( $_[1] ) }

1;
