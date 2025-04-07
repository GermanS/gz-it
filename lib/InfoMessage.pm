package InfoMessage;

use strict;
use warnings;

use SharedPart;

use Moose;

has 'info'  => ( is => 'ro', required => 1, isa => 'SharedPart' );
has 'email' => ( is => 'ro', required => 1, isa => 'Str|Undef' );

sub from_str {
        my ( $class, $str ) = @_;

        if( $str =~ /^((\d{4}-\d{2}-\d{2})\s+(\d{2}:\d{2}:\d{2}))\s+(\S+)\s/) {

                my $created = $1;
                my $int_id  = $4;

                my $info = SharedPart -> new(
                        created => $created,
                        int_id  => $int_id,
                        str     => $str,
                );

                return $class -> new(
                        info  => $info,
                        email => undef,
                );
        }

        return;
}

__PACKAGE__ -> meta() -> make_immutable();

1;