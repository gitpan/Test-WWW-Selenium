package WWW::Selenium::Server::StaticHandler;

use strict;
use warnings;
use HTTP::Status;

sub _guess_type {
    local $_ = $_[0];

    return 'text/html' if /\.html?$/i;
    return 'text/javascript' if /\.js$/i;
    return 'text/css' if /\.css$/i;
    return 'image/png' if /\.png$/i;
    return 'image/gif' if /\.gif$/i;
    return 'application/octet-stream';
}

sub make_handler {
    my( $FS_PATH, $BASE_PATH ) = @_;

    return sub {
        my( $request, $response ) = @_;
        my $path = $request->uri->path;

        $path =~ s{^\Q$BASE_PATH\E}//i;
        my $fspath = File::Spec->catfile( $FS_PATH, ( split '/', $path ) );

        if( -f $fspath ) {
            $response->code( RC_OK );
            $response->message( 'OK' );

            open( my $in, '<:raw', $fspath );
            local $/;

            $response->content( readline $in );
            $response->headers->header( 'Content-Type' => _guess_type( $fspath ) );
            $response->headers->header( 'Content-Length' => -s $fspath );
        } else {
            $response->code( RC_NOT_FOUND );
            $response->message( 'Not found' );
        }
    }
}

1;
