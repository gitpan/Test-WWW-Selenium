#!/usr/bin/perl -w
use warnings;
use strict;
use inc::Module::Install;

name            'Test-WWW-Selenium';
build_requires  'Test::More'        => '0.42';
license         'perl';

# examples of other commands:
# requires        'Carp'              => 0;

if ($^O eq 'darwin') {
    recommends 'Mac::AppleScript' => '0.04';
}

# Auto-install all dependencies from CPAN
auto_install;

# Generate the Makefile
WriteAll;
