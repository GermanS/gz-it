package GZIT;

use Dancer2;
use Dancer2::Plugin::Database;

our $VERSION = '0.1';

my $handler = sub {
        my @users = ();
        my $count = 0;

        my $email = params -> { 'email' } || q{};

        if( $email ) {
                my $sth = database -> prepare( filter_query() );
                $sth -> execute( ( $email ) x 2 );

                @users = @{ $sth -> fetchall_arrayref({}) };

                $count = database -> selectrow_hashref(
                        count_query(),
                        undef,
                        ( $email ) x 2
                ) -> { 'count' };
        }

        template 'index' => {
                title => 'Gz.IT поиск',
                dyn_users => \@users,
                dyn_email => $email,
                dyn_count => $count,
        };
};

sub _query {
        return qq/
                select created, str, int_id from message where int_id in (
                        select int_id from log where position( ? in address ) >= 1
                )
                union
                select created, str, int_id from log where int_id in (
                        select int_id from log where position( ? in address ) >= 1
                )
        /;
}

sub filter_query {
        return sprintf "%s order by int_id desc, created desc limit 100", _query();
}

sub count_query {
        return sprintf "select count(*) from ( %s ) logs", _query();
}

get  '/' => $handler;
post '/' => $handler;

1;
