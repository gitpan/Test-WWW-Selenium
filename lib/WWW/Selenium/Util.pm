package WWW::Selenium::Util;
{
  $WWW::Selenium::Util::VERSION = '1.33';
}
# ABSTRACT: Utility code to help test using Selenium

use strict;
use warnings;
use IO::Socket;
use base 'Exporter';
our @EXPORT_OK = qw(server_is_running);


sub server_is_running {
    my $host = $ENV{SRC_HOST} || shift || 'localhost';
    my $port = $ENV{SRC_PORT} || shift || 4444;

    return ($host, $port) if IO::Socket::INET->new(
        PeerAddr => $host,
        PeerPort => $port,
    );
    return;

}

1;



=pod

=head1 NAME

WWW::Selenium::Util - Utility code to help test using Selenium

=head1 VERSION

version 1.33

=head1 SYNOPSIS

WWW::Selenium::Util contains utility functions to help use Selenium
in your test scripts:

  use WWW::Selenium::Util qw/server_is_running/;
  use Test::More;

  if (server_is_running) {
      plan tests => 1;
  }
  else {
      plan skip_all => "No selenium server found!";
      exit 0;
  }

  # ... your tests ...

=head1 NAME

WWW::Selenium::Util - Utility code to help test using Selenium

=head1 FUNCTIONS

=head2 server_is_running( $host, $port )

Returns true if a Selenium server is running.  The host and port 
parameters are optional, and default to C<localhost:4444>.

Environment vars C<SRC_HOST> and C<SRC_PORT> can also be used to
determine the server to check.

=head1 AUTHORS

Written by Luke Closs <selenium@5thplane.com>

=head1 LICENSE

Copyright (c) 2007 Luke Closs <lukec@cpan.org>

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut


__END__

