package WWW::Selenium::Server::RpcHandler;

use strict;
use warnings;
use WWW::Selenium::Server::Queue;

use POE;
use HTTP::Status qw(RC_OK);
use POE::Component::Server::HTTP qw(RC_WAIT);
use Frontier::RPC2;

sub Queues { 'WWW::Selenium::Server::Queue' }

my $coder = Frontier::RPC2->new;

sub _log {
    return unless $ENV{SELENIUM_SERVER_LOG};
    print STDERR @_, "\n";
}

sub rpc2 {
    my( $request, $response ) = @_;
    my $call = $coder->decode( $request->content );
    $response->content_type( 'text/xml' );
    $response->code( RC_WAIT );

    my $cb = sub {
        my $elt = shift;

	_log( 'rpc: gotResult: ', $elt );
        $response->content( $coder->encode_response( $elt ) );
        $response->continue if $response->code == RC_WAIT;
        $response->code( RC_OK );
    };

    my $command = $call->{method_name};
    my @args    = @{$call->{value}};

    _log( 'rpc: addCommand: ', $command );
    my $string = sprintf '| %s | %s | %s |', $command,
                     ( defined $args[0] ? $args[0] : '' ),
                     ( defined $args[1] ? $args[1] : '' );

    Queues->enqueue_command( $string );
    Queues->dequeue_response( $cb );

    if( $command eq 'testComplete' ) {
        Queues->enqueue_response( 'OK' );
    }

    return RC_WAIT;
}

1;
