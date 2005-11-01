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
