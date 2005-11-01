package WWW::Selenium::Server::ReverseProxyHandler;

use strict;
use warnings;

use POE;
use HTTP::Status qw(RC_OK RC_NO_CONTENT);
use POE::Component::Server::HTTP qw(RC_WAIT);
use POE::Component::Client::UserAgent;

my $initialized;

sub _start {
    $_[KERNEL]->alias_set( 'reverse_proxy' );
}

sub init {
    return if $initialized;

    POE::Component::Client::UserAgent->new;
    $initialized = 1;
}

sub shutdown {
    return unless $initialized;
    POE::Kernel->call( $poe_kernel->alias_resolve( 'useragent' ), "shutdown" );
}

sub make_handler {
    my( $realhost, $localhost ) = @_;

    init();

    my $response_cb = sub {
        my( $orig_uri, $orig_response ) = @{$_[ARG0]};
        my( $request, $response, $entry ) = @{$_[ARG1]};

        $orig_response->code( $response->code );
        $orig_response->message( $response->message );
        $orig_response->content( $response->content );

        foreach my $header ( $response->header_field_names ) {
            ( my $value = $response->header( $header ) )
              =~ s{^$realhost}{$localhost};
            $orig_response->header( $header => $value );
        }

        $orig_response->continue;
    };

    my $session = POE::Session->create
        ( inline_states  => { _start   => \&_start,
                              response => $response_cb },
        );

    my $rhost = $realhost; $rhost =~ s{^http://([^/]+)/?.*$}{$1};
    return sub {
        my( $request, $response ) = @_;

        ( my $path = $request->uri ) =~ s{^http://[^/]+/}/$realhost/;
        my $prequest = HTTP::Request->new( $request->method => $path );
        $prequest->content( $request->content );

        foreach my $name ( $request->header_field_names ) {
            if( lc( $name ) eq 'host' ) {
                $prequest->push_header( Host => $rhost );
            } else {
                $prequest->push_header( $name => $request->header( $name ) );
            }
        }

        my $postback = $session
                         ->postback( 'response', $request->uri, $response );

        $poe_kernel->post( useragent => request =>
                           request => $prequest, response => $postback );
        $response->code( RC_WAIT );
        return RC_WAIT;
    };
}

1;
