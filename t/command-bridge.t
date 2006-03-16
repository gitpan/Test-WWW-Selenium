#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 60;
use lib 't/lib';
use lib 'lib';
use File::Path qw(rmtree);

BEGIN {
    use_ok 'WWW::Selenium::CommandBridge';
}

my $cmd_file = 't/selenium/driven.commands';
my $res_file = 't/selenium/driven.results';

Command_flow: {
    for my $backend (qw(InMemory File)) {
        print "Testing $backend backend\n";
        my $scb = new_bridge( backend => $backend );
        $scb->reset;
        # test driver will add a command
        $scb->add('open', '/foo');
        if ($backend eq 'File') {
            is cat($cmd_file), '|open|/foo||';
            ok !-e $res_file, "!-e $res_file";
        }
        # browser will request a command
        my $cmd = $scb->get_next_command;
        isa_ok $cmd, 'WWW::Selenium::Command';
        is $cmd->command, 'open';
        is $cmd->opt1, '/foo';
        is $cmd->opt2, '';
        is $cmd->result, '';
        # browser will report back the results
        $cmd = $scb->get_next_command('OK', 'non-blocking');
        is $cmd, undef, 'get_next_command should return nothing';
        if ($backend eq 'File') {
            ok !-e $cmd_file, "!-e $cmd_file";
            is cat($res_file), 'OK';
        }
        # test driver will get the result
        my $result = $scb->get_result;
        if ($backend eq 'File') {
            ok !-e $cmd_file, "!-e $cmd_file";
            ok !-e $res_file, "!-e $res_file";
        }
        is $result, 'OK';
        # test driver will add another command
        $scb->add('verifyText', 'foo', 'bar');
        if ($backend eq 'File') {
            is cat($cmd_file), '|verifyText|foo|bar|';
            ok !-e $res_file, "!-e $res_file";
        }
        # browser will get this new command
        $cmd = $scb->get_next_command;
        is $cmd->command, 'verifyText';
        is $cmd->opt1, 'foo';
        is $cmd->opt2, 'bar';
        is $cmd->result, '';
        # browser will report back results again
        $cmd = $scb->get_next_command('ERROR', 'non-blocking');
        is $cmd, undef, 'get_next_command should return nothing';
        if ($backend eq 'File') {
            ok !-e $cmd_file, "!-e $cmd_file";
            is cat($res_file), 'ERROR';
        }
        # test driver will get the result
        $result = $scb->get_result;
        if ($backend eq 'File') {
            ok !-e $cmd_file, "!-e $cmd_file";
            ok !-e $res_file, "!-e $res_file";
        }
        is $result, 'ERROR';
        # finished testing
        $scb->finished;
        $cmd = $scb->get_next_command;
        is $cmd, undef;
    }
}

Test_driver_timeout: {
    my $scb = new_bridge();
    # test driver will add a command
    $scb->add('open', '/foo');
    $scb->set_timeout(1);
    my $start = time;
    $scb->get_result;
    my $duration = time - $start;
    ok $duration <= 3, "get_result with timeout of 1 took $duration seconds";
}

Add_wiki_command: {
    my $scb = new_bridge();
    for my $line ('| verifyText | foo | bar |',
                  '|verifyText|foo|bar|') {
        $scb->add($line);
        my $cmd = $scb->get_next_command;
        isa_ok $cmd, 'WWW::Selenium::Command';
        is $cmd->command, 'verifyText';
        is $cmd->opt1, 'foo';
        is $cmd->opt2, 'bar';
        is $cmd->result, '';
    }
}

Default_backend: {
    my $scb = WWW::Selenium::CommandBridge->new;
    isa_ok $scb, 'WWW::Selenium::CommandBridge';
    isa_ok $scb->{backend}, 'WWW::Selenium::CommandBridge::Backend::File';
}

Invalide_backend: {
    eval { WWW::Selenium::CommandBridge->new(backend => 'Quantum') };
    ok $@;
    like $@, qr#Cannot load the 'Quantum'#;
}


sub new_bridge {
    my (%opts) = @_;
    $opts{backend} ||= 'InMemory';
    $opts{tmp_dir} = 't/selenium' if $opts{backend} eq 'File';
    rmtree 't/selenium';
    my $scb = WWW::Selenium::CommandBridge->new( %opts );
    isa_ok $scb, 'WWW::Selenium::CommandBridge';
    return $scb;
}

sub cat {
    my $file = shift;
    open(my $fh, $file) or warn "Can't open $file: $!" and return;
    my $content;
    {
        local $/ = undef;
        $content = <$fh>;
    }
    close $fh or die "Can't close $fh: $!";
    return $content;
}
 

