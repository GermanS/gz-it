package Storage;

use strict;
use warnings;


sub store {
        my ( $dbh, $object ) = @_;

        my %supported_types_to_store = (
                IncomingMessage    => \&_save_to_table_message,
                DelayedMessage     => \&_save_to_table_log,
                UndeliveredMessage => \&_save_to_table_log,
                DeliveredMessage   => \&_save_to_table_log,
                AdditionalMessage  => \&_save_to_table_log,
                InfoMessage        => \&_save_to_table_log,
        );

        if( !$dbh ) {
                die "Dbh is required";
        }

        if( !$object ) {
                die "Object is required for processing";
        }

        if( !ref( $object ) ) {
                die sprintf "An object of one of the types is required [%s]", join ', ', keys %supported_types_to_store;
        }

        if( my $coderef = $supported_types_to_store{ ref( $object ) } ) {
                return $coderef -> ( $dbh, $object );
        }

        die "Programm misconfiguration bro! Fix it ASAP!!!";
}

sub _save_to_table_log {
        my ( $dbh, $struct ) = @_;

        return $dbh -> do(
                'insert into log (created, int_id, str, address) values (?, ?, ?, ?)',
                undef,
                $struct -> info() -> created(),
                $struct -> info() -> int_id(),
                $struct -> info() -> str_without_dt(),
                $struct -> email()
        );
}

sub _save_to_table_message {
        my ( $dbh, $struct ) = @_;

        return $dbh -> do(
                'insert into message (created, id, int_id, str) values (?, ?, ?, ?)',
                undef,
                $struct -> info() -> created(),
                $struct -> id(),
                $struct -> info() -> int_id(),
                $struct -> info() -> str_without_dt(),
        );
}

1;