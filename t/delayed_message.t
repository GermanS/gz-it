use strict;
use warnings;

use Test::More;

use_ok 'DelayedMessage';

{
        my $str = '2012-02-13 14:39:47 1RwtJs-0009RI-7r == mkkucgyyzrji@gmail.com R=dnslookup T=remote_smtp defer (-1): domain matches queue_smtp_domains, or -odqs set';

        my $msg = DelayedMessage -> from_str( $str );

        isa_ok $msg, 'DelayedMessage';

        is $msg -> email(), 'mkkucgyyzrji@gmail.com'
                => 'email should be equal to "mkkucgyyzrji@gmail.com"';

        is $msg -> info() -> created(), '2012-02-13 14:39:47'
                => 'created should be equal to "2012-02-13 14:39:47"';

        is $msg -> info() -> int_id(), '1RwtJs-0009RI-7r'
                => 'int_id should be equal to "1RwtJs-0009RI-7r"';

        is $msg -> info() -> str_without_dt(), '1RwtJs-0009RI-7r == mkkucgyyzrji@gmail.com R=dnslookup T=remote_smtp defer (-1): domain matches queue_smtp_domains, or -odqs set'
                => 'int_id should be equal to "1RwtJs-0009RI-7r == ..."';

}

done_testing();