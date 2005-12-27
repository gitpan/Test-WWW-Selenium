package Test::WWW::Selenium;

use strict;
use base qw(WWW::Selenium);

our $VERSION = '0.02';

=head1 NAME

Test::WWW::Selenium - Tesing applications using WWW::Selenium

=head1 SYNOPSIS

    ues Test::More tests => 4;
    use Test::WWW::Selenium;
    use WWW::Selenium::Launcher::Default;
    use WWW::Selenium::RpcCommandProcessor;

    my $selenium = Test::WWW::Selenium->new
        ( WWW::Selenium::RpcCommandProcessor->new
            ( 'http://localhost:8080/selenium-driver' ),
          WWW::Selenium::Launcher::Default->new );

    $selenium->open_ok( 'http://localhost:8080/index.html' );
    $selenium->title_is( 'Some title' );
    $selenium->click_and_wait_ok( 'link_id' );
    $selenium->title_like( qr/title/i );
    $selenium->stop;

=head1 REQUIREMENTS

The tests need to be located on the same machine as the browser that will
be driving the testing session.

=head1 DESCRIPTION

This module is a C<WWW::Selenium> subclass providing some methods
useful for writing tests. For each Selenium command (open, click,
click_and_wait, ...) there is a corresponding <command>_ok method that
checks its return value (open_ok, click_ok, click_and_wait_ok).

For each Selenium getter (get_title, ...) there are six autogenerated
methods (<getter>_is, <getter>_isnt, <getter>_like, <getter>_unlike,
<getter>_contains, <getter>_lacks) to check the value of the
attribute.

You can use bot Java-style (openOk, titleIs, titleLacks) and
Perl-style (open_ok, title_is, title_lacks) in method names.

=head1 DRIVEN MODE

Please see the section with the same name in L<WWW::Selenium|WWW::Selenium>.

=cut

use Test::LongString;
use Test::More;
use Test::Builder;

our $AUTOLOAD;

my $Test = Test::Builder->new;

my %comparator =
  ( is       => 'is_string',
    isnt     => 'isnt',
    like     => 'like_string',
    unlike   => 'unlike_string',
    contains => 'contains_string',
    lacks    => 'lacks_string'
    );

my %no_locator =
  ( title    => 1,
    );

sub AUTOLOAD {
    my $name = $AUTOLOAD;

    $name =~ s/.*:://;
    return if $name eq 'DESTROY';
    my $sub;

    if( $name =~ /(\w+)
                  (?:
                   _(is|isnt|like|unlike|contains|lacks)
                   |
                   (Is|Isnt|Like|Unlike|Contains|Lacks)
                   )$/x ) {
        my $getter = 'get_' . $1;
        my $comparator = $comparator{$2 || lc( $3 )};

	if( $no_locator{$1} ) {
	  $sub = sub {
              my( $self, $str, $desc ) = @_;

	      local $Test::Builder::Level = $Test::Builder::Level + 1;
	      no strict 'refs';
	      return &$comparator( $self->$getter, $str, $desc );
	    };
        } else {
	  $sub = sub {
              my( $self, $locator, $str, $desc ) = @_;

	      local $Test::Builder::Level = $Test::Builder::Level + 1;
	      no strict 'refs';
	      return &$comparator( $self->$getter( $locator ), $str, $desc );
	    };
	}
    } elsif( $name =~ /(\w+)(?:_(ok)|(Ok))$/ ) {
        my $cmd = $1;

        $sub = sub {
            my( $self, $arg1, $arg2, $desc ) = @_;

            local $Test::Builder::Level = $Test::Builder::Level + 1;
            return ok( $self->$cmd( $arg1, $arg2 ), $desc );
        };
    }

    if( $sub ) {
        no strict 'refs';
        *{$AUTOLOAD} = $sub;
        goto &$AUTOLOAD;
    } else {
        $WWW::Selenium::AUTOLOAD = $AUTOLOAD;
        goto &WWW::Selenium::AUTOLOAD;
    }
}

1;

__END__

=head1 AUTHOR

Mattia Barbon <mbarbon@cpan.org>

=head1 LICENSE

Copyright (c) 2005 Mattia Barbon <mbarbon@cpan.org>

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself
