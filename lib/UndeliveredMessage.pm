package UndeliveredMessage;

use strict;
use warnings;

use SharedPart;

use Moose;

has 'info'  => ( is => 'ro', required => 1, isa => 'SharedPart' );
has 'email' => ( is => 'ro', required => 1, isa => 'Str' );

sub from_str {
        my ( $class, $str ) = @_;

        if( $str =~ /^((\d{4}-\d{2}-\d{2})\s+(\d{2}:\d{2}:\d{2}))\s+(\S+)\s\*\*\s+(\S+)/) {

                my $created = $1;
                my $int_id  = $4;
                my $email = $5;

                $email =~ s/:$//;

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

sub store {
        my ( $self, $dbh ) = @_;

        require Storage;

        return Storage::save_to_table_log( $dbh, $self );
}

__PACKAGE__ -> meta() -> make_immutable();

1;