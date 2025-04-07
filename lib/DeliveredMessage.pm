package DeliveredMessage;

use strict;
use warnings;

use SharedPart;

use Moose;

has 'info'  => ( is => 'ro', required => 1, isa => 'SharedPart' );
has 'email' => ( is => 'ro', required => 1, isa => 'Str' );

sub from_str {
        my ( $class, $str ) = @_;

        # write once and read never ;)
        if( $str =~ /((\d{4}-\d{2}-\d{2})\s+(\d{2}:\d{2}:\d{2}))\s+(\S+)\s+=>\s+(?::\w+:\s+)?(?:([^\s]+)|<([^\s>]+)>)/ ) {

                my $created = $1;
                my $int_id  = $4;
                my $email   = $5;

                # TODO: спросить у Романа, что делать с :blackhole:
                # может, разбор почтового адреса не нужен? Хотя вряд ли не нужен
                $email =~ s/^\<//;
                $email =~ s/\>$//;

                my $info = SharedPart -> new(
                        created => $created,
                        int_id  => $int_id,
                        str     => $str,
                );

                return $class -> new(
                        info  => $info,
                        email => $email,
                );
        }

        return;
}

__PACKAGE__ -> meta() -> make_immutable();

1;