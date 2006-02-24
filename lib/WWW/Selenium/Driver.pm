package WWW::Selenium::Driver;
use strict;
use warnings;
use WWW::Selenium::CommandBridge;
use CGI qw/header/;

sub new {
    my ($class, %args) = @_;
    my $self = { };
    bless $self, $class;

    $self->{bridge} = WWW::Selenium::CommandBridge->new(backend => $args{backend});
    return $self;
}

sub drive {
    my ($self, $cgi) = @_;

    my $result = $cgi->param('commandResult');
    if ($cgi->param('seleniumStart') or $result) {
        my $next;
        eval {
            $next = $self->{bridge}->get_next_command($result);
        };
        if ($@) {
            warn $@;
            return header . "Timed out!";
        }
        return header . $next->as_wiki;
    }
    # useful redirect for the browser
    return "Location: SeleneseRunner.html\n\n";
}

1;
