#!/opt/lang/perl/dev/bin/perl
use strict;
use warnings;
use CGI;
use WWW::Selenium::Driver;

my $sel = WWW::Selenium::Driver->new;
print $sel->drive(CGI->new);
