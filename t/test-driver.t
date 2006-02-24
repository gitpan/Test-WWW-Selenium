#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw/no_plan/;
use lib 'lib';
use lib 't/lib';

BEGIN {
    use_ok 'WWW::Selenium';
}

Simple_test: {
    my $sel = WWW::Selenium->new( backend => 'InMemory' );
    isa_ok $sel, 'WWW::Selenium';
    my $cb = WWW::Selenium::CommandBridge::Backend::InMemory->new;
    $cb->{result} = 'OK';
    is $sel->open('/foo'), 'OK';
    my $cmd = $cb->get_command;
    isa_ok $cmd, 'WWW::Selenium::Command';
    is $cmd->{cmd}, 'open';
    is $cmd->{opt1}, '/foo';
    is $cmd->{opt2}, '';
    $cb->{result} = 'SUCCESS';
    is $sel->verifyLocation('/foo'), 'SUCCESS';
    $cmd = $cb->get_command;
    isa_ok $cmd, 'WWW::Selenium::Command';
    is $cmd->{cmd}, 'verifyLocation';
    is $cmd->{opt1}, '/foo';
    is $cmd->{opt2}, '';
    $cb->{result} = 'FAILURE: Not enough Juggling';
    is $sel->verify_text('id=foo', 'monkey'), 'FAILURE: Not enough Juggling';
    $cmd = $cb->get_command;
    isa_ok $cmd, 'WWW::Selenium::Command';
    is $cmd->{cmd}, 'verifyText';
    is $cmd->{opt1}, 'id=foo';
    is $cmd->{opt2}, 'monkey';
}

# Verify that our AUTOLOADed closures work correctly
Sticky_closures: {
    my $sel = WWW::Selenium->new( backend => 'InMemory' );
    isa_ok $sel, 'WWW::Selenium';
    my $cb = WWW::Selenium::CommandBridge::Backend::InMemory->new;
    $cb->{result} = 'OK';
    is $sel->open('/foo'), 'OK';
    my $cmd = $cb->get_command;
    isa_ok $cmd, 'WWW::Selenium::Command';
    is $cmd->{cmd}, 'open';
    is $cmd->{opt1}, '/foo';
    is $cmd->{opt2}, '';
    $cb->{result} = 'OK';
    is $sel->open('/bar'), 'OK';
    $cmd = $cb->get_command;
    isa_ok $cmd, 'WWW::Selenium::Command';
    is $cmd->{cmd}, 'open';
    is $cmd->{opt1}, '/bar';
    is $cmd->{opt2}, '';
}
