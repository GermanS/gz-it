package IncomingMessage;

use strict;
use warnings;

use SharedPart;

use Moose;

has 'info' => ( is => 'ro', required => 1, isa => 'SharedPart' );
has 'id'   => ( is => 'ro', required => 1, isa => 'Str' );

sub from_str {
        my ( $class, $str ) = @_;

        if( $str =~ /^((\d{4}-\d{2}-\d{2})\s+(\d{2}:\d{2}:\d{2}))\s+(\S+)\s+<=.*id=(\S+)/ ) {

                my $created = $1;
                my $int_id  = $4;
                my $id      = $5;

                my $info = SharedPart -> new(
                        created => $created,
                        int_id  => $int_id,
                        str     => $str,
                );

                return $class -> new(
                        id   => $id,
                        info => $info,
                );
        }

        return;
}

__PACKAGE__ -> meta() -> make_immutable();

1;