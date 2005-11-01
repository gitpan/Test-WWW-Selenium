#!/usr/bin/perl -w

use lib 't/lib';
use SeleniumTest;

use strict;
use Test::More tests => 7;

$test->start;

$test->openOk( $test_url, '', 'opening the page' );
$test->titleIs( 'Test index.html', 'check title' );
$test->clickAndWaitOk( '1', '', 'navigate to second page' );
$test->titleIsnt( 'Test xxx.html', 'sanity check' );
$test->titleIs( 'Test 1.html', 'more sanity check' );
ok( $test->verifyTitle( 'Test 1.html' ), 'check inherited AUTOLOAD' );
is( $test->getTitle, 'Test 1.html', 'check inherited AUTOLOAD' );

$test->stop;
