package WWW::Selenium::CommandBridge::Backend;
use warnings;
use strict;
use Carp qw(croak);

sub set_timeout {
    my ($self, $timeout) = @_;
    $self->{timeout} = $timeout;
}

sub reset;
sub queue_command;
sub get_result;

sub result;
sub get_command;
sub finished;
    
1;

__END__

Class::DBI based system notes

get_result:
    my $timeout = time() + $TIMEOUT;
    while(1) {
        my @cmds = grep { $_->result } $class->retrieve_all;
        if (@cmds) {
            my $cmd = shift @cmds;
            sel_log("get_result: " . $cmd->as_string);
            my $result = $cmd->result;
            $cmd->delete;
            return $result;
        }
        sel_log("no commands with results");
        last if time() > $timeout;
        select(undef, undef, undef, 0.1);
    };

    sel_log("could not find any results!");
    return 'NO RESULT';
}

get_next_command:
    my @cmds = $class->retrieve_all;
    warn "Found more than one unfinished command:"
         . join("\n", map { $_->as_string } @cmds) if @cmds > 1;

    if ($result) {
        $
        my $finished = shift @cmds;
        $finished->result($result);
        $finished->update;
    }

    # now we wait for another command to come!
    my $timeout = time + $TIMEOUT;
    while(@cmds < 1) {
        return if $nonblocking;
        select(undef, undef, undef, 0.1);
        croak("Timed out waiting for a command") if time > $timeout;
        sel_log("Looking for commands!");
        @cmds = $class->search(result => '');
    }
    sel_log("get_next: " . $cmds[0]->as_string);
    return $cmds[0];
