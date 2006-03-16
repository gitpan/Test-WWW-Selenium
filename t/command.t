#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 74;
use Test::Exception;
use lib 'lib';

BEGIN {
    use_ok 'WWW::Selenium::Command';
}

New_with_one_opt: {
    for my $line (q#| open | /foo |#,
                  q#|open|/foo|#,
                  q#| open|/foo |#,
                  q#| open|/foo ||#,
                  q#| open|/foo | |#,
                 ) {
        my $cmd;
        lives_ok { $cmd = WWW::Selenium::Command->new($line) };
        isa_ok $cmd, 'WWW::Selenium::Command';
        is $cmd->command, 'open';
        is $cmd->opt1, '/foo';
        is $cmd->opt2, '';
        is $cmd->result, '';
        is $cmd->as_wiki, '|open|/foo||';
        is $cmd->as_string, 
           'Command: "open", opt1: "/foo", opt2: "", result: ""';
    }
}

New_with_two_opts: {
    for my $line (q#| verifyText | foo | bar |#,
                  q#|verifyText|foo|bar|#,
                  q#| verifyText|foo |bar  |  #,
                  q#| verifyText|foo |   bar|#,
                 ) {
        my $cmd;
        lives_ok { $cmd = WWW::Selenium::Command->new($line) };
        isa_ok $cmd, 'WWW::Selenium::Command';
        is $cmd->command, 'verifyText';
        is $cmd->opt1, 'foo';
        is $cmd->opt2, 'bar';
        is $cmd->result, '';
        is $cmd->as_wiki, '|verifyText|foo|bar|';
        is $cmd->as_string, 
           'Command: "verifyText", opt1: "foo", opt2: "bar", result: ""';
    }
}

Invalid_commands: {
    throws_ok { WWW::Selenium::Command->new('|||') }
              qr#Can't parse line#;
}
