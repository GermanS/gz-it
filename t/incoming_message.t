use strict;
use warnings;

use Test::More;

use_ok 'IncomingMessage';

{
        my $str = '2012-02-13 14:39:40 1RwtJs-0009RI-SI <= tpxmuwr@somehost.ru H=mail.somehost.com [84.154.134.45] P=esmtp S=1236 id=120213143519.COM_FM_END.84876@whois.somehost.ru';

        my $msg = IncomingMessage -> from_str( $str );

        isa_ok $msg, 'IncomingMessage';

        is $msg -> id(), '120213143519.COM_FM_END.84876@whois.somehost.ru'
                => 'id should be equal to "120213143519.COM_FM_END.84876@whois.somehost.ru"';

        is $msg -> info() -> created(), '2012-02-13 14:39:40'
                => 'created should be equal to "2012-02-13 14:39:40"';

        is $msg -> info() -> int_id(), '1RwtJs-0009RI-SI'
                => 'int_id should be equal to "1RwtJs-0009RI-SI"';

        is $msg -> info() -> str_without_dt(), '1RwtJs-0009RI-SI <= tpxmuwr@somehost.ru H=mail.somehost.com [84.154.134.45] P=esmtp S=1236 id=120213143519.COM_FM_END.84876@whois.somehost.ru'
                => 'str should be equal to "1RwtJs-0009RI-SI <= ..."';
}

{
        my @negative_cases = (
                '',
                '2012-02-13 14:39:22 1RookS-000Pg8-VO == udbbwscdnbegrmloghuf@london.com R=dnslookup T=remote_smtp defer (-44): SMTP error from remote mail server after RCPT T
O:<udbbwscdnbegrmloghuf@london.com>: host mx0.gmx.com [74.208.5.90]: 450 4.3.2 Too many mails (mail bomb), try again in 1 hour(s) 25 minute(s) and see ( http:
//portal.gmx.net/serverrules ) {mx-us011}',
                '2012-02-13 14:39:22 1RookS-000Pg8-VO ** fwxvparobkymnbyemevz@london.com: retry timeout exceeded',
                '2012-02-13 14:39:22 1QcGoJ-000DxQ-75 Completed',
                '2012-02-13 14:39:24 1RvhTH-000B9y-TD giaterran.bir.ru [194.85.61.78] Operation timed out',
                '2012-02-13 14:39:30 1RwtJi-000AoQ-85 => :blackhole: <tpxmuwr@somehost.ru> R=blackhole_router/->',
                '2012-02-13 14:39:57 1RwtJY-0009RI-E4 -> ldtyzggfqejxo@mail.ru R=dnslookup T=remote_smtp H=mxs.mail.ru [94.100.176.20] C="250 OK id=1RwtK9-0004SS-Fm"'
        );

        foreach my $str ( @negative_cases ) {
                my $msg = IncomingMessage -> from_str( $str );

                ok !$msg, sprintf 'Object was not created from str "%s"', $str;
        }
}

done_testing()