package SeleniumTest;

use strict;
use warnings;
use base qw(Exporter);

use IO::Socket::INET;
use Module::Build;

my $build;

BEGIN {
    $build = Module::Build->current;
    unless( $build->notes( 'tests' ) ) {
        eval 'use Test::More skip_all => q[Full test not wanted]';
    }
}

use WWW::Selenium;
use WWW::Selenium::Launcher::Default;
use WWW::Selenium::RpcCommandProcessor;
use Test::WWW::Selenium;

our @EXPORT = qw($selenium $test $test_url);

my $HTTPD_PORT    = '12543';
my $SELENIUM_PORT = $build->notes( 'poe_server' ) ? '12544' : '8080';
our $test_url = $build->notes( 'poe_server' )     ?
    "http://localhost:$SELENIUM_PORT/index.html" :
    "http://localhost:8080/AUT/000000A/http/localhost:$HTTPD_PORT/index.html";

our $selenium = WWW::Selenium->new
  ( WWW::Selenium::RpcCommandProcessor->new
        ( "http://localhost:$SELENIUM_PORT/selenium-driver",
          ),
    WWW::Selenium::Launcher::Default->new );

$selenium->set_url( "http://localhost:$SELENIUM_PORT/selenium-driver" );
$selenium->set_throw( 0 );

our $test = Test::WWW::Selenium->new
  ( WWW::Selenium::RpcCommandProcessor->new
        ( "http://localhost:$SELENIUM_PORT/selenium-driver",
          ),
    WWW::Selenium::Launcher::Default->new );

$test->set_url( "http://localhost:$SELENIUM_PORT/selenium-driver" );
$test->set_throw( 0 );

use IPC::Open2;

my( @rd, @wr );
my( $httpd, $poe );

sub start {
    $httpd  = open2( $rd[0], $wr[0], $^X,
                     't/script/httpd.pl', $HTTPD_PORT, 't/htdocs' );
    $poe    = open2( $rd[1], $wr[1], $^X,
                     'script/selenium_server.pl',
                     "http://localhost:$SELENIUM_PORT/",
                     "http://localhost:$HTTPD_PORT/" )
      if $build->notes( 'poe_server' );
    for ( 1 .. 10 ) {
      if(    IO::Socket::INET->new( "localhost:$HTTPD_PORT" )
          && IO::Socket::INET->new( "localhost:$SELENIUM_PORT" ) ) {
          last;
      };
      sleep 1;
    }
    # Python server is *slow*
    $selenium->set_timeout( '20' ) if $build->notes( 'python_server' );
    $test->set_timeout( '20' ) if $build->notes( 'python_server' );
    $SIG{INT} = sub { stop() };
}

sub stop {
    foreach my $pid ( $httpd, $poe ) {
        next unless defined $pid;
        kill 3, $pid;
        waitpid $pid, 0;
        undef $pid;
    }
}

start();

END {
    stop();
}

1;
