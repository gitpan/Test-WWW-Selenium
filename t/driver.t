#!/usr/bin/perl
use strict;
use warnings;
use Test::More qw/no_plan/;
use lib 'lib';
use lib 't/lib';

BEGIN {
    use_ok 'WWW::Selenium::Driver';
    use_ok 'WWW::Selenium::Command';
}

Runner_redirect: {
    my $sel = WWW::Selenium::Driver->new( backend => 'InMemory' );
    isa_ok $sel, 'WWW::Selenium::Driver';
    like $sel->drive(MockCGI->new), qr#Location: SeleneseRunner\.html#;
}

Simple_test: {
    my $sel = WWW::Selenium::Driver->new( backend => 'InMemory' );
    isa_ok $sel, 'WWW::Selenium::Driver';
    my $mock_cb = WWW::Selenium::CommandBridge::Backend::InMemory->new;
    $mock_cb->queue_command(WWW::Selenium::Command->new('open', '/foo', ''));
    like $sel->drive(MockCGI->new( seleniumStart => 1 )), 
         qr#\|open\|/foo\|\|#;
    $mock_cb->queue_command(WWW::Selenium::Command->new('verifyText', 'foo', 'bar'));
    like $sel->drive(MockCGI->new(commandResult => 'OK')), 
         qr#\|verifyText\|foo\|bar\|#;
    is $mock_cb->{result}, 'OK';
}

package MockCGI;
use strict;
use warnings;

sub new {
    my ($class, %opts) = @_;
    my $self = \%opts;
    bless $self, $class;
}

sub param { $_[0]->{$_[1]} }

1;
