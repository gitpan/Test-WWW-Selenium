#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

eval 'require WWW::Selenium::Utils';
if ($@) {
    plan skip_all => "WWW::Selenium::Utils is missing";
    exit;
}
else {
    plan tests => 3;
}

my $converter = 'script/convert_wiki_to_perl.pl';
ok -e $converter;

Successful_conversion: {
    my $file = make_test_wikifile();
    my $output = qx($^X -Ilib $converter $file 2>&1);
    are_same($output, <<EOT);
#!$^X
use strict;
use warnings;
use Test::More tests => 2;
use Test::WWW::Selenium;
use WWW::Selenium::Launcher::Default;

my \$BASE_URL = 'http://localhost';

my \$no_browser = shift;
unless (\$no_browser) {
    my \$browser = WWW::Selenium::Launcher::Default->new;
    \$browser->launch("\$BASE_URL/selenium/SeleneseRunner.html");
    END { \$browser->close if \$browser }
}

diag "Title: Some title";
my \$sel = Test::WWW::Selenium->new();
\$sel->open_ok('/foo');
\$sel->verifyText_ok('id=foo', 'bar');
EOT
}

Wiki_error: {
    my $file = make_test_wikifile('with errors');
    my $output = qx($^X -Ilib $converter $file 2>&1);
    are_same($output, <<EOT);
Error parsing $file:
line 4: Invalid line (outlandish)
EOT
}

{
    my $have_diff;
    BEGIN {
        eval 'require Test::Differences';
        $have_diff = !$@;
    }

    sub are_same {
        if ($have_diff) {
            return Test::Differences::eq_or_diff(@_);
        }
        is $_[0], $_[1];
    }
}

sub make_test_wikifile {
    my $option = shift || '';
    my $file = 't/test.wiki';
    open(my $fh, ">$file") or die "Can't open $file: $!";
    print $fh <<EOT;
|Some title|
|open|/foo|
|verifyText|id=foo|bar|
EOT
    if ($option eq 'with errors') {
        print $fh " outlandish\n| this is bad too|\n";
    }
    close $fh or die "Can't close $file: $!";
    return $file;
}
