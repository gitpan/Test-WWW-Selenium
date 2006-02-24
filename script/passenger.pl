#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw/no_plan/;
use Test::WWW::Selenium;
use WWW::Selenium::Launcher::Safari;

my $no_browser = shift;
my $browser;
unless ($no_browser) {
    $browser = WWW::Selenium::Launcher::Safari->new;
    $browser->launch('http://localhost/~lukec/selenium/SeleneseRunner.html');
}

my $sel = Test::WWW::Selenium->new();
$sel->open_ok('/~lukec/simple.cgi');
$sel->verify_location_ok('/~lukec/simple.cgi');
$sel->verify_title_ok('Awesome Awesomeness');
$sel->type_ok('name', 'luke');
$sel->click_and_wait_ok('.submit');
$sel->verify_text_present_ok('luke is the most awesome');
$sel->type_ok('name', 'Sarathy');
$sel->click_and_wait_ok('.submit');
$sel->verify_text_present_ok('super awesome');
$sel->type_ok('name', 'Helen');
$sel->click_and_wait_ok('.submit');
$sel->verify_text_present_ok('Sorry');
$browser->close;
