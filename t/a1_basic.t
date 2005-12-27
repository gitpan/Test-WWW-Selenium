#!/usr/bin/perl -w

use lib 't/lib';
use SeleniumTest;

use strict;
use Test::More tests => 6;

$selenium->start;

ok( $selenium->open( $test_url ) );
ok( $selenium->verify_title( 'Test index.html' ) );
ok( $selenium->click_and_wait( '1' ) );
ok( !$selenium->verify_title( 'Test xxx.html' ) );
ok( $selenium->verify_title( 'Test 1.html' ) );
is( $selenium->get_value( 'text1' ), '1234' );

$selenium->stop;
