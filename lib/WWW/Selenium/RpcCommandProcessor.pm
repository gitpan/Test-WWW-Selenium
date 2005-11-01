package WWW::Selenium::RpcCommandProcessor;

use strict;
use warnings;
use Frontier::Client;

sub new {
    my( $class, $url ) = @_;
    my $self = bless { url   => $url . '/RPC2',
                       }, $class;

    $self->{rpc} = Frontier::Client->new( url => $self->url );

    return $self;
}

sub start { }

sub stop {
    my $self = shift;

    $self->do_command( 'testComplete', undef, undef, 1 );
}

sub do_command {
    my( $self, $command, $arg1, $arg2, $noresult ) = @_;
    my $result = $self->rpc->call( $command,
                                   $arg1 ? ( $arg1 ) : (),
                                   $arg2 ? ( $arg2 ) : () );
    return $result;
}

sub rpc { $_[0]->{rpc} }
sub url { $_[0]->{url} }

1;
