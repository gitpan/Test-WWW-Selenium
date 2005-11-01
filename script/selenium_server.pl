#!/usr/bin/perl -w

use strict;
use warnings;
use POE qw(Session);
use POE::Component::Server::HTTP;
use Alien::Selenium;
use WWW::Selenium::Server::StaticHandler;
use WWW::Selenium::Server::DriverHandler;
use WWW::Selenium::Server::ReverseProxyHandler;
use WWW::Selenium::Server::RpcHandler;

my $LOCALHOST = shift;
my $REALHOST = shift;
my $SELENIUM = Alien::Selenium->path;
my $PORT = $LOCALHOST =~ m{//\w+:(\d+)} ? $1 : 80;

POE::Component::Server::HTTP->new
    ( Port => $PORT,
      ContentHandler => {
          '/'                       => WWW::Selenium::Server::ReverseProxyHandler::make_handler( $REALHOST, $LOCALHOST ),
          '/selenium-driver/'       => WWW::Selenium::Server::StaticHandler::make_handler( $SELENIUM, '/selenium-driver' ),
          '/selenium-driver/driver' => \&WWW::Selenium::Server::DriverHandler::driver,
          '/selenium-driver/RPC2'   => \&WWW::Selenium::Server::RpcHandler::rpc2,
      },
    );

POE::Session->create
  ( inline_states  => { _start => \&_start },
    package_states => [ main   => [ qw(callback ticker) ] ],
  );

sub _start {
    $_[KERNEL]->alias_set( 'runner' );
    $_[KERNEL]->delay_set( 'ticker', 2 ); # allows stopping with Ctrl-C
}

sub ticker {
    $_[KERNEL]->delay_set( 'ticker', 2 )
}

sub callback {
    my $cb = $_[ARG0][0];
    my( @data ) = @{$_[ARG1]};

    $cb->( @data );
}

POE::Kernel->run();

POE::Kernel->call( POE::Kernel->alias_resolve( 'httpd' ), "shutdown" );
WWW::Selenium::Server::ReverseProxyHandler->shutdown;
