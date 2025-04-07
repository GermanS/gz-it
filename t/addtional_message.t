use strict;
use warnings;

use Test::More;

use_ok( 'AdditionalMessage' );

{
        my $str = '2012-02-13 14:40:05 1RwtJk-0009RI-3n -> azkunmnkqt@mail.ru R=dnslookup T=remote_smtp H=mxs.mail.ru [94.100.176.20]* C="250 OK id=1RwtKG-0001At-T5';

        my $msg = AdditionalMessage -> from_str( $str );

        is $msg -> email(), 'azkunmnkqt@mail.ru'
                => 'email should be equal to "azkunmnkqt@mail.ru"';

        is $msg -> info() -> created(), '2012-02-13 14:40:05'
                => 'created should be equal to "2012-02-13 14:40:05"';

        is $msg -> info() -> int_id(), '1RwtJk-0009RI-3n'
                => 'int_id should be equal to "1RwtJk-0009RI-3n"';

        is $msg -> info() -> str_without_dt(), '1RwtJk-0009RI-3n -> azkunmnkqt@mail.ru R=dnslookup T=remote_smtp H=mxs.mail.ru [94.100.176.20]* C="250 OK id=1RwtKG-0001At-T5',
                => 'info should be equal to "1RwtJk-0009RI-3n -> ..."';
}

done_testing();