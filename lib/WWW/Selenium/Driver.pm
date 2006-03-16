package WWW::Selenium::Driver;
use strict;
use warnings;
use WWW::Selenium::CommandBridge;
use CGI qw/header/;

sub new {
    my ($class, %args) = @_;
    my $self = { };
    bless $self, $class;

    $self->{bridge} = WWW::Selenium::CommandBridge->new( %args );
    return $self;
}

sub drive {
    my ($self, $cgi) = @_;

    my $response;
    eval {
        # Requests from the browser
        my $result = $cgi->param('commandResult');
        if ($cgi->param('seleniumStart') or $result) {
            my $next = $self->{bridge}->get_next_command($result);
            $response = header . $next->as_wiki;
        }

        # Requests from a test script
        my $cmd = $cgi->param('cmd');
        my $opt1 = $cgi->param('opt1');
        my $opt2 = $cgi->param('opt2');
        if (defined $cmd) {
            die "opt1 is mandatory\n" unless defined $opt1;
            $self->{bridge}->add($cmd, $opt1, $opt2);
            $response = header . "Result: " . $self->{bridge}->get_result;
        }
    };
    if ($@) {
        return header . "Error: $@";
    }
    return $response if defined $response;

    # useful redirect for the browser
    return "Location: SeleneseRunner.html\n\n";
}

1;
