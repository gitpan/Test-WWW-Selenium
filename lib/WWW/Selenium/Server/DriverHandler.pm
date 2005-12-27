package WWW::Selenium::Server::DriverHandler;

use strict;
use warnings;
use WWW::Selenium::Server::Queue;

use POE;
use HTTP::Status qw(RC_OK RC_NO_CONTENT);
use POE::Component::Server::HTTP qw(RC_WAIT);

sub Queues { 'WWW::Selenium::Server::Queue' }

sub _log {
    return unless $ENV{SELENIUM_SERVER_LOG};
    print STDERR @_, "\n";
}

sub driver {
    my( $request, $response ) = @_;
    my %query = $request->uri->query_form;

    $response->content_type( 'text/plain' );
    $response->code( RC_WAIT );

    if( exists $query{commandResult} ) {
        _log( 'driver: addResult: ', $query{commandResult} );
        Queues->enqueue_response( $query{commandResult} );
    }

    my $cb = sub {
        my $elt = shift;

	_log( 'driver: gotResult: ', $elt );
        $response->content( $elt );
        $response->continue if $response->code == RC_WAIT;
        $response->code( RC_OK );
    };
    my $runner = $poe_kernel->alias_resolve( 'runner' );

    if( exists $query{seleniumStart} || exists $query{commandResult} ) {
        _log( 'driver: addResult' );
        Queues->dequeue_command( $runner->postback( 'callback', $cb ) );
    } elsif( exists $query{addCommand} ) {
        _log( 'driver: addCommand: ', $query{addCommand} );
        Queues->enqueue_command( $query{addCommand} );
        $response->code( RC_NO_CONTENT );
    } elsif( exists $query{getResult} ) {
        _log( 'driver: getResult' );
        Queues->dequeue_response( $runner->postback( 'callback', $cb ) );
    }

    return $response->code;
}

1;
