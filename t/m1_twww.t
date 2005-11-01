#!/usr/bin/perl -w

use lib 't/lib';
use SeleniumTest;

use strict;
use Test::More tests => 7;

$test->start;

$test->open_ok( $test_url, '', 'opening the page' );
$test->title_is( 'Test index.html', 'check title' );
$test->click_and_wait_ok( '1', '', 'navigate to second page' );
$test->title_isnt( 'Test xxx.html', 'sanity check' );
$test->title_is( 'Test 1.html', 'more sanity check' );
ok( $test->verify_title( 'Test 1.html' ), 'check inherited AUTOLOAD' );
is( $test->get_title, 'Test 1.html', 'check inherited AUTOLOAD' );

$test->stop;
