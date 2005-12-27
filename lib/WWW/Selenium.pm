package WWW::Selenium;

use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

WWW::Selenium - Perl driver for the Selenium testing framework

=head1 SYNOPSIS

    use WWW::Selenium;
    use WWW::Selenium::Launcher::Default;
    use WWW::Selenium::RpcCommandProcessor;

    my $selenium = WWW::Selenium->new
        ( WWW::Selenium::RpcCommandProcessor->new
            ( 'http://localhost:8080/selenium-driver' ),
          WWW::Selenium::Launcher::Default->new );

    $selenium->open( 'http://localhost:8080/index.html' );
    $selenium->verify_title( 'Some title' );
    $selenium->click_and_wait( 'link_id' );
    $selenium->stop;

=head1 DESCRIPTION

This module uses Selenium in driven mode to test web applications. The
Selenium method calls are automatically generated; this means the full
Selenoum API (including any user-contributed extension) is available
through C<WWW::Selenium>.

You can use bot Java-style (open, verifyTitle, clickAndWait) and
Perl-style (open, verify_title, click_and_wait) in method names.

=head1 DRIVEN MODE

C<WWW::Selenium> uses Selenium in driven mode: the Selenium test runner gets
the Selenese commands from a server, which in turn gets the commands from
a Perl script. The Selenium server needs to be up and running before Selenium
can be used from Perl (or from any other language). The easiest way to
achieve this is to save the code below in a .pm file and C<use()> it in
every script.

    package SeleniumTest;
    
    use strict;
    use warnings;
    use base qw(Exporter);
    
    use IO::Socket::INET;
    
    use WWW::Selenium;
    use WWW::Selenium::Launcher::Default;
    use WWW::Selenium::RpcCommandProcessor;
    use Test::WWW::Selenium;
    
    our @EXPORT = qw($selenium $test_url);
    
    my $SELENIUM_PORT = '8080';
    our $test_url = "http://localhost:$SELENIUM_PORT/index.html";
    
    our $selenium = Test::WWW::Selenium->new
      ( WWW::Selenium::RpcCommandProcessor->new
            ( "http://localhost:$SELENIUM_PORT/selenium-driver",
              ),
        WWW::Selenium::Launcher::Default->new );
    
    $selenium->set_url( "http://localhost:$SELENIUM_PORT/selenium-driver" );
    $selenium->set_throw( 0 );
    
    use IPC::Open2;
    
    my( @rd, @wr );
    my( $poe );
    
    sub start {
        $poe    = open2( $rd[0], $wr[0], $^X,
                         'script/selenium_server.pl',
                         "http://localhost:$SELENIUM_PORT/",
                         "http://my.application.net:80/" );
        for ( 1 .. 10 ) {
          if( IO::Socket::INET->new( "localhost:$SELENIUM_PORT" ) ) {
              last;
          };
          sleep 1;
        }
        # Python server is *slow*
    #    $selenium->set_timeout( '20' );
        $SIG{INT} = sub { stop() };
    }
    
    sub stop {
        foreach my $pid ( $poe ) {
            next unless defined $pid;
            kill 3, $pid;
            waitpid $pid, 0;
            undef $pid;
        }
    }
    
    start();
    
    END {
        stop();
    }
    
    1;

This will export a C<$selenium> variable that can be used in the tests.
Remember to correct the path to the selenium_server script and the URL
for the application under test.

=cut

our $AUTOLOAD;

sub _make_getter {
    my( $getter ) = @_;

    sub {
        my( $self ) = shift;
        my $result = $self->processor->do_command( $getter, @_ );

        return wantarray ?
          split /,/, $result, -1 : # preserve trailing null fields
          $result;
    };
}

sub _make_command {
    my( $command, $result ) = @_;

    sub {
        my( $self ) = shift;
        if( $self->processor->do_command( $command, @_ ) eq $result ) {
            return if $self->get_throw;
            return 1;
        } else {
            die if $self->get_throw;
            return 0;
        }
    };
}

sub AUTOLOAD {
    my $name = $AUTOLOAD;

    $name =~ s/.*:://;
    $name =~ s/\_([^_]+)/ucfirst $1/eg;
    return if $name eq 'DESTROY';
    my $sub;

    if( $name =~ /^(?:verify|assert)/ ) {
        $sub = _make_command( $name, 'PASSED' );
    } elsif( $name =~ /^get/ ) {
        $sub = _make_getter( $name );
    } else {
        $sub = _make_command( $name, 'OK' );
    }

    die "Could not load '", $AUTOLOAD. "'" unless $sub;

    {
        no strict 'refs';
        *{$AUTOLOAD} = $sub;
    }

    goto &$AUTOLOAD;
}

=head1 METHODS

=head2 new

    my $selenium = WWW::Selenium->new( $command_processor, $launcher );

Creates a new Selenium instance; C<$command processor> will almost
always be a C<WWW::Selenium::RpcCommandProcessor> instance; C<$launcher>
determines which browser is used to run the tests. Under Windows and Mac OS X
the default browser is used (the one started by 'cmd /c start <url> and
'open <url>'); under Unix the first known browser found in the path is used
(see C<WWW::Selenium::Launcher::UnixDefault> for the list).

To use a different browser, just pass the appropriate launcher to the
constructor. In most cases C<<WWW::Selenium::Launcher::Base->new( 'command' )>>
will return an appropriate launcher.

=cut

sub new {
    my( $class, $processor, $launcher ) = @_;
    my( $self ) = bless { processor => $processor,
                          launcher  => $launcher,
                          throw     => 0,
                          }, $class;

    return $self;
}

sub start {
    my( $self ) = @_;

    $self->processor->start;
    $self->launcher->launch( $self->get_url . '/SeleneseRunner.html' );
}

sub stop {
    my( $self ) = @_;

    $self->launcher->close;
    $self->processor->stop;
}

=head2 get_url/set_url

    my $url = $selenium->get_url;
    $selenium->set_url( "http://localhost:$SELENIUM_PORT/selenium-driver" );

Get/set the URL at which the Selenium driver is located.

=head2 get_throw/set_throw

    my $is_throwing = $selenium->get_throw;
    $selenium->set_throw( 1 );

Set to a true value for the various assert* commands to throw an exception
when the assertion fails.

=cut

sub set_url { $_[0]->{url} = $_[1] }
sub get_url { $_[0]->{url} }
sub set_throw { $_[0]->{throw} = $_[1] ? 1 : 0 }
sub get_throw { $_[0]->{throw} }

sub launcher { $_[0]->{launcher} }
sub processor { $_[0]->{processor} }

1;

__END__

=head1 AUTHOR

Mattia Barbon <mbarbon@cpan.org>

=head1 LICENSE

Copyright (c) 2005 Mattia Barbon <mbarbon@cpan.org>

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself
