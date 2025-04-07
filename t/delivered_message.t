use strict;
use warnings;

use Test::More;

use_ok( 'DeliveredMessage' );

{
        my $str = '2012-02-13 14:40:05 1RwtJd-0009RI-Ns => nmwmcxudy@inbox.ru R=dnslookup T=remote_smtp H=mxs.mail.ru [94.100.176.20]* C="250 OK id=1RwtKH-0001DM-JP';

        my $msg = DeliveredMessage -> from_str( $str );

        is $msg -> email(), 'nmwmcxudy@inbox.ru'
                => 'email should be equal to "nmwmcxudy@inbox.ru"';

        is $msg -> info() -> created(), '2012-02-13 14:40:05'
                => 'created should be equal to "2012-02-13 14:40:05"';

        is $msg -> info() -> int_id(), '1RwtJd-0009RI-Ns'
                => 'int_id should be equal to "1RwtJd-0009RI-Ns"';

        is $msg -> info() -> str_without_dt(), '1RwtJd-0009RI-Ns => nmwmcxudy@inbox.ru R=dnslookup T=remote_smtp H=mxs.mail.ru [94.100.176.20]* C="250 OK id=1RwtKH-0001DM-JP',
                => 'info should be equal to "1RwtJd-0009RI-Ns -> ..."';
}

{
        my $str = '2012-02-13 14:40:05 1RwtKH-000EbZ-5u => :blackhole: <tpxmuwr@somehost.ru> R=blackhole_router';

        my $msg = DeliveredMessage -> from_str( $str );

        is $msg -> email(), 'tpxmuwr@somehost.ru'
                => 'email should be equal to "tpxmuwr@somehost.ru"';

        is $msg -> info() -> created(), '2012-02-13 14:40:05'
                => 'created should be equal to "2012-02-13 14:40:05"';

        is $msg -> info() -> int_id(), '1RwtKH-000EbZ-5u'
                => 'int_id should be equal to "1RwtKH-000EbZ-5u"';

        is $msg -> info() -> str_without_dt(), '1RwtKH-000EbZ-5u => :blackhole: <tpxmuwr@somehost.ru> R=blackhole_router',
                => 'info should be equal to "1RwtKH-000EbZ-5u => ..."';
}

done_testing();