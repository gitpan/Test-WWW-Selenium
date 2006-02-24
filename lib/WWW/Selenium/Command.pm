package WWW::Selenium::Command;
use warnings;
use strict;
use Carp qw(croak);

sub new {
    my ($class, @details) = @_;
    if (@details == 1) {
        @details = parse_wiki_line($details[0]);
    }

    my $self = { cmd => $details[0],
                 opt1 => $details[1],
                 opt2 => $details[2] || '',
                 result => ''
               };
    bless $self, $class;
    return $self;
}

sub command { $_[0]->{cmd} }
sub opt1 { $_[0]->{opt1} }
sub opt2 { $_[0]->{opt2} }
sub result { $_[0]->{result} }

sub parse_wiki_line {
    my $line = shift;
    if ($line =~ /^\s*                   # some possible leading space
                \|\s*([^\|]+?)\s*\|    # cmd
                (?:\s*([^\|]+?)\s*\|)? # opt1 (optional)
                (?:\s*([^\|]*)\s*\|)? # opt2 (optional)
                \s*$/x) {
        my ($cmd, $opt1, $opt2) = ($1, $2, $3 || '');
        $opt2 =~ s/\s*$//; # above regex can leave whitespace here
        return ($cmd, $opt1, $opt2);
    }
    croak("Can't parse line: ($line)");
}

sub as_string {
    my ($self) = @_;
    return sprintf('Command: "%s", opt1: "%s", opt2: "%s", result: "%s"',
                   $self->command, $self->opt1, $self->opt2, $self->result);
}

sub as_wiki {
    my $self = shift;
    return join('|', '', $self->command, $self->opt1, $self->opt2, '');
}

1;
