package WWW::Selenium::Launcher::Safari;

use strict;
use warnings;
use base qw(WWW::Selenium::Launcher::Base);
use Carp qw(croak);

sub new {
    my( $class ) = @_;

    eval 'require Mac::AppleScript';
    return $class->SUPER::new( 'open -a Safari' ) if $@;

    # use applescript magic to open a brawser
    return $class->SUPER::new( \&apple_script );
}

sub apple_script {
    my ($action, $url) = @_;
    my $script;
    if ($action eq 'launch') {
        print "Launching Safari via AppleScript...\n";
        $script = <<EOT;
tell application "Safari"
    activate
    open location "$url"
end tell
EOT
    }
    elsif ($action eq 'close') {
        print "Closing Safari via AppleScript...\n";
        $script = <<EOT;
tell application "Safari"
    quit
end tell
EOT
    }
    else {
        croak("Sorry - '$action' is not a valid action");
    }
    Mac::AppleScript::RunAppleScript($script) or 
        croak("Couldn't run AppleScript - error=$@");
}

1;
