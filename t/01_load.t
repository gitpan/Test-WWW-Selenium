#!/usr/bin/perl -w

use strict;
use Test::More tests => 14;
use Module::Build;

my $build = Module::Build->current;

use_ok( 'WWW::Selenium::Launcher::Base' );
use_ok( 'WWW::Selenium::Launcher::Pick' );
use_ok( 'WWW::Selenium::Launcher::WindowsDefault' );
use_ok( 'WWW::Selenium::Launcher::UnixDefault' );
use_ok( 'WWW::Selenium::Launcher::MacDefault' );
use_ok( 'WWW::Selenium::Launcher::Default' );
use_ok( 'WWW::Selenium::RpcCommandProcessor' );
use_ok( 'WWW::Selenium' );
use_ok( 'Test::WWW::Selenium' );

SKIP: {
    skip 'RPC Server not wanted', 5
      unless $build->notes( 'server' );

    use_ok( 'WWW::Selenium::Server::Queue' );
    use_ok( 'WWW::Selenium::Server::DriverHandler' );
    use_ok( 'WWW::Selenium::Server::ReverseProxyHandler' );
    use_ok( 'WWW::Selenium::Server::RpcHandler' );
    use_ok( 'WWW::Selenium::Server::StaticHandler' );
}
