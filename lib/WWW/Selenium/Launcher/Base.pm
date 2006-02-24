package WWW::Selenium::Launcher::Base;

use strict;
use warnings;
use IPC::Open3;

sub new {
    my( $class, $command ) = @_;

    bless { command => $command,
            pid     => -1,
            }, $class;
}

sub launch {
    my( $self, $url ) = @_;

    my $cmd = $self->{command};
    if (ref($cmd) eq 'CODE') {
        $cmd->('launch', $url);
    }
    else {
        $self->exec("$cmd $url");
    }
}

sub exec {
    my( $self, $command ) = @_;
    my( $rd, $wr, $err );

    $self->{pid} = open3( $wr, $rd, $err, $command ) ;

    close $rd;
    close $wr;
    close $err if $err;
}

sub close {
    my( $self ) = @_;

    if (ref($self->{command}) eq 'CODE') {
        $self->{command}->('close');
    }
    else {
        kill 3, $self->{pid} if $self->{pid} >= 0;
    }
}

1;
