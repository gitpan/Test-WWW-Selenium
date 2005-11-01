#!/usr/bin/perl -w

use lib 't/lib';
use SeleniumTest;

use strict;
use Test::More tests => 5;

$selenium->start;

ok( $selenium->open( $test_url ) );
ok( $selenium->verifyTitle( 'Test index.html' ) );
ok( $selenium->clickAndWait( '1' ) );
ok( !$selenium->verifyTitle( 'Test xxx.html' ) );
ok( $selenium->verifyTitle( 'Test 1.html' ) );

$selenium->stop;
