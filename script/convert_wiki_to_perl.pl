#!/usr/bin/perl
use strict;
use warnings;
use WWW::Selenium::Utils qw(parse_wikifile);

my $filename = shift;
my $results = parse_wikifile(filename => $filename);

if ($results->{errors}) {
    print STDERR "Error parsing $filename:\n",
                 join("\n", @{$results->{errors}}), "\n";
    exit -1;
}

my @tests;
for my $row (@{$results->{rows}}) {
    my ($cmd, @opts) = @$row;
    pop @opts if $opts[1] eq '&nbsp;';
    my $opt_args = "'" . join(q(', '), @opts) . "'";
    push @tests, "\$sel->${cmd}_ok($opt_args);\n";
}

my $num_tests = @tests;
print <<EOT;
#!$^X
use strict;
use warnings;
use Test::More tests => $num_tests;
use Test::WWW::Selenium;
use WWW::Selenium::Launcher::Default;

my \$BASE_URL = 'http://localhost';

my \$no_browser = shift;
unless (\$no_browser) {
    my \$browser = WWW::Selenium::Launcher::Default->new;
    \$browser->launch("\$BASE_URL/selenium/SeleneseRunner.html");
    END { \$browser->close if \$browser }
}

diag "Title: $results->{title}";
my \$sel = Test::WWW::Selenium->new();
EOT

print @tests;

