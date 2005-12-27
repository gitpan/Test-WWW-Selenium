#!/usr/bin/perl -w

use lib 't/lib';
use SeleniumTest;

use strict;
use Test::More tests => 14;

$test->start;

$test->open_ok( $test_url, '', 'opening the page' );
$test->title_is( 'Test index.html', 'check title' );
$test->click_and_wait_ok( '1', '', 'navigate to second page' );
$test->title_isnt( 'Test xxx.html', 'sanity check' );
$test->title_is( 'Test 1.html', 'more sanity check' );
ok( $test->verify_title( 'Test 1.html' ), 'check inherited AUTOLOAD' );
is( $test->get_title, 'Test 1.html', 'check inherited AUTOLOAD' );
$test->value_is( 'text1', '1234', 'sanity check' );
$test->value_isnt( 'text1', '12345', 'more sanity checking' );
SKIP: {
    skip 'Hang with current Selenium version', 1;

    $test->value_isnt( 'text2', '1234', 'element not there in get_text()' );
}
$test->type_ok( 'text1', '12345', 'check type()' );
$test->value_is( 'text1', '12345', 'check type() actually type()d' );
SKIP: {
    skip 'Hang with current Selenium version', 2;

    $test->type_ok( 'text2', '12345', 'element not there in type()' );
    $test->value_isnt( 'text2', '12345', 'check test does not hang' );
}

$test->stop;
