package WWW::Selenium::CommandBridge::Backend::File;
use warnings;
use strict;
use Carp qw(croak);
use base 'WWW::Selenium::CommandBridge::Backend';
use WWW::Selenium::Command;

my $self; # singleton

sub new {
    my ($class, %opts) = @_;

    my $dir = '/tmp/selenium';
    unless (-d $dir) {
        mkdir $dir or die "Can't mkdir $dir: $!";
    }

    $self = {
              command_file => "$dir/driven.commands",
              result_file => "$dir/driven.results",
              sleep_time => 0.1,
              timeout => 5,
              verbose => 0,
            };
    bless $self, $class;
    return $self;
}

sub FINISHED_TOKEN () { '__FINISHED__' }

sub reset {
    my ($self) = @_;
    unlink $self->{command_file};
    unlink $self->{result_file};
}

sub queue_command {
    my ($self, $cmd) = @_;
    my $tmpfile = $self->{command_file} . ".$$";
    write_file($self->{command_file}, $cmd->as_wiki);
}

sub get_command {
    my ($self, $nonblocking) = @_;

    my $cmd_file = $self->{command_file};
    my $cb = sub {
        if (-e $cmd_file) {
            my $line = cat($cmd_file);
            cb_log("get_command - read ($line)\n");
            return '' if $line eq FINISHED_TOKEN;
            my $cmd = WWW::Selenium::Command->new( $line );
            unlink $cmd_file or die "Can't unlink $cmd_file: $!";
            return $cmd;
        }
    };
    return $self->poll($cb, $nonblocking);
}

sub get_result {
    my ($self, $nonblocking) = @_;

    my $res_file = $self->{result_file};
    my $cb = sub {
        if (-e $res_file) {
            my $result = cat($res_file);
            chomp $result;
            unlink $res_file or die "Can't unlink $res_file: $!";
            return $result;
        }
    };
    return $self->poll($cb, $nonblocking);
}

sub result {
    my ($self, $result) = @_;
    write_file($self->{result_file}, $result);
}

sub finished {
    my ($self) = @_;
    write_file($self->{command_file}, FINISHED_TOKEN);
}
    
# calls $cb until it returns a defined value
sub poll {
    my ($self, $cb, $nonblocking) = @_;

    my $sleep_time = $self->{sleep_time};
    my $timeout = time + $self->{timeout};
    do {
        my $result = $cb->();
        return $result if $result;
        return if defined $result and $result eq '';
        return if $nonblocking;
        croak "Timed out!" if time > $timeout;
        select(undef, undef, undef, $sleep_time);
    } while 1;
}

# utility

sub cat {
    my ($file) = @_;
    open(my $fh, $file) or die "Can't open $file: $!";
    my $contents;
    {
        local $/ = undef;
        $contents = <$fh>;
    }
    close $fh;
    cb_log("Read ($contents) from $file\n");
    return $contents;
}

sub write_file {
    my ($filename, $content) = @_;
    my $tmp_file = "$filename.$$";
    BEGIN { unlink $tmp_file if $tmp_file };
    open(my $fh, ">$tmp_file") or die "Can't open $tmp_file: $!";
    print $fh $content;
    close $fh or die "Can't write $tmp_file: $!";
    rename $tmp_file, $filename or die "Can't rename $tmp_file, $filename: $!";
    chmod 0666, $filename or die "Can't chmod 0666, $filename: $!";
    cb_log("Wrote ($content) to $filename");
}

sub cb_log {
    print STDERR $_[0], "\n" if $self->{verbose};
}

1;
