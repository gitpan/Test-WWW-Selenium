package WWW::Selenium;
use strict;
use warnings;
use WWW::Selenium::CommandBridge;

our $VERSION = '0.06';

=head1 NAME

WWW::Selenium - Perl driver for the Selenium testing framework

=head1 SYNOPSIS

    use WWW::Selenium;
    use WWW::Selenium::Launcher::Default;

    my $selenium = WWW::Selenium->new;

    $selenium->open( 'http://localhost:8080/index.html' );
    $selenium->verify_title( 'Some title' );
    $selenium->click_and_wait( 'link_id' );
    $selenium->stop;

=head1 DESCRIPTION

Selenium (http://selenium.openqa.org/) is a test tool for web
applications.  Selenium tests run directly in a browser, just as real
users do.  And they run in Internet Explorer, Mozilla and Firefox on
Windows, Linux, and Macintosh. Selenium in not meant for unit testing
but is invluable for functional/acceptance testing of applications
relying on JavaScript.

This module uses Selenium in driven mode to test web applications. The
Selenium method calls are automatically generated; this means the full
Selenium API (including any user-contributed extension) is available
through C<WWW::Selenium>.

You can use bot Java-style (open, verifyTitle, clickAndWait) and
Perl-style (open, verify_title, click_and_wait) in method names.

=head1 DRIVEN MODE

C<WWW::Selenium> uses Selenium in driven mode: the Selenium test runner uses
a driver service which gets the commands from a CommandBridge.  
A C<WWW::Selenium> object will put its commands in the CommandBridge, and then
wait for the driver and browser to execute the command, and post the result
back to the driver.

The web browser will load SeleneseRunner.html which contains the Selenium
browser-bot.  The browser-bot will fetch commands and post results to a 
script called 'driver'.  An example driver:


    #!/usr/bin/perl
    use CGI;
    use WWW::Selenium::Handler;

    my $sel = WWW::Selenium::Handler->new;
    print $sel->drive(CGI->new);

=head1 METHODS

=head2 new

    my $selenium = WWW::Selenium->new( $command_processor, $launcher );

Creates a new Selenium instance; C<$command processor> will almost
always be a C<WWW::Selenium::RpcCommandProcessor> instance; C<$launcher>
determines which browser is used to run the tests. Under Windows and Mac OS X
the default browser is used (the one started by 'cmd /c start <url> and
'open <url>'); under Unix the first known browser found in the path is used
(see C<WWW::Selenium::Launcher::UnixDefault> for the list). The browser
list checked in the UnixDefault and Pick launchers can be changed using
the SELENIUM_BROWSERS environment variable.

To use a different browser, just pass the appropriate launcher to the
constructor. In most cases C<<WWW::Selenium::Launcher::Base->new( 'command' )>>
will return an appropriate launcher.

=cut

sub new {
    my ($class, %args) = @_;
    my $self = { };
    bless $self, $class;

    $self->{bridge} = WWW::Selenium::CommandBridge->new(backend => $args{backend});
    $self->{bridge}->reset;
    return $self;
}

our $AUTOLOAD;

sub AUTOLOAD {
    my $command = $AUTOLOAD;

    # determine selenium command
    $command =~ s/.*:://;
    # map this_style to thisStyle
    $command =~ s/\_([^_]+)/ucfirst $1/eg;
    return if $command eq 'DESTROY';

    my $sub = sub {
        my ($self, @opts) = @_;
        $self->{bridge}->add($command, @opts);
        my $result = $self->{bridge}->get_result;
        return $result;
    };

    die "Could not load '$AUTOLOAD'" unless $sub;
    {
        no strict 'refs';
        *{$AUTOLOAD} = $sub;
    }

    goto &$AUTOLOAD;
} 

=head2 get_url/set_url

    my $url = $selenium->get_url;
    $selenium->set_url( "http://localhost:$SELENIUM_PORT/selenium-driver" );

Get/set the URL at which the Selenium driver is located.

=cut

sub set_url { $_[0]->{url} = $_[1] }
sub get_url { $_[0]->{url} }

1;

__END__

=head1 AUTHOR

Maintained by Luke Closs <lukec@cpan.org>

Originally by Mattia Barbon <mbarbon@cpan.org>

=head1 LICENSE

Copyright (c) 2006 Luke Closs <lukec@cpan.org>
Copyright (c) 2005, 2006 Mattia Barbon <mbarbon@cpan.org>

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself
