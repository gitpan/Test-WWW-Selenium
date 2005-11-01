#!/usr/bin/perl -w

use lib 'lib';

use strict;
use warnings;
use HTTP::Daemon;
use WWW::Selenium::Server::StaticHandler;
use File::Spec::Functions qw(rel2abs);

my $PORT = shift;
my $PATH = shift;

my $d = HTTP::Daemon->new( LocalPort => $PORT,
                           ReuseAddr => 1 ) || die;
my $h = WWW::Selenium::Server::StaticHandler::make_handler
  ( rel2abs( $PATH ), '/' );

while( my $c = $d->accept ) {
    while( my $req = $c->get_request ) {
        my $res = HTTP::Response->new;

        $h->( $req, $res );
        $res->headers->header( 'Connection' => 'keep-alive' );
        $c->send_response( $res );
    }

    $c->close;
    undef $c;
}
