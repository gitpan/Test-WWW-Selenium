#!/usr/bin/perl -w

use strict;
use Module::Build;

my $poe_server = Module::Build->y_n
  ( 'Do you want to install the Selenium POE/RPC server?', 'y' );
my $python_server = $poe_server ? 0 : Module::Build->y_n
  ( 'Do you want to use the Python RPC server?', 'n' );
my $tests = ( $poe_server || $python_server ) ? Module::Build->y_n
  ( 'Do you want to run the full test suite?', 'n' ) : 0;

my %server_deps =
  ( 'POE'                               => 0.29,
    'POE::Component::Server::HTTP'      => 0,
    'POE::Component::Client::UserAgent' => 0,
    'Frontier::RPC2'                    => 0,
    'Alien::Selenium'                   => 0,
   );
my %test_deps =
  ( 'HTTP::Daemon'                      => 0,
   );

my $build = Module::Build->new
  ( module_name       => 'Test::WWW::Selenium',
    license           => 'perl',
    requires          => { 'LWP'                               => 5.8,
                           'Test::LongString'                  => 0,
                           'Frontier::Client'                  => 0,
                           ( $poe_server ? ( %server_deps ) : () ),
                           },
    build_requires    => { 'Test::More'                        => 0.47,
                           ( $tests ? ( %test_deps ) : () ),
                           },
    ( $poe_server ?
      ( script_files  => [ 'script/selenium_server.pl' ],
        ) : () ),
    );

$build->notes( poe_server => $poe_server );
$build->notes( python_server => $python_server );
$build->notes( server => $poe_server || $python_server );
$build->notes( tests  => $tests );

$build->create_build_script;
