use strict;
use warnings;

use Test::More;

use_ok( 'UndeliveredMessage' );

{
        my $str = '2012-02-13 14:39:45 1RwtEk-0002zL-IF ** ksppvvxxdo@yahoo.com R=dnslookup T=remote_smtp: SMTP error from remote mail server after end of data: host mta7.am0.yahoodns.net [67.195.168.230]: 554 delivery error: dd Sorry your message to ksppvvxxdo@yahoo.com cannot be delivered. This account has been disabled or discontinued [#102]. - mta1051.mail.ac4.yahoo.com';

        my $msg = UndeliveredMessage -> from_str( $str );

        is $msg -> email(), 'ksppvvxxdo@yahoo.com'
                => 'email should be equal to "ksppvvxxdo@yahoo.com"';

        is $msg -> info() -> created(), '2012-02-13 14:39:45'
                => 'created should be equal to "2012-02-13 14:39:45"';

        is $msg -> info() -> int_id(), '1RwtEk-0002zL-IF'
                => 'int_id should be equal to "1RwtEk-0002zL-IF"';

        is $msg -> info() -> str_without_dt(), '1RwtEk-0002zL-IF ** ksppvvxxdo@yahoo.com R=dnslookup T=remote_smtp: SMTP error from remote mail server after end of data: host mta7.am0.yahoodns.net [67.195.168.230]: 554 delivery error: dd Sorry your message to ksppvvxxdo@yahoo.com cannot be delivered. This account has been disabled or discontinued [#102]. - mta1051.mail.ac4.yahoo.com',
                => 'info should be equal to "1RwtEk-0002zL-IF ** ..."';
}

{
        my $str = '2012-02-13 14:39:31 1RgE7s-000Bou-TJ ** fwxvparobkymnbyemevz@london.com: retry timeout exceeded';

        my $msg = UndeliveredMessage -> from_str( $str );

        isa_ok $msg, 'UndeliveredMessage';

        is $msg -> email(), 'fwxvparobkymnbyemevz@london.com'
                => 'email should be equal to "fwxvparobkymnbyemevz@london.com"';

        is $msg -> info() -> created(), '2012-02-13 14:39:31'
                => 'created should be equal to "2012-02-13 14:39:31"';

        is $msg -> info() -> int_id(), '1RgE7s-000Bou-TJ'
                => 'int_id should be equal to "1RgE7s-000Bou-TJ"';

        is $msg -> info() -> str_without_dt(), '1RgE7s-000Bou-TJ ** fwxvparobkymnbyemevz@london.com: retry timeout exceeded'
                => 'info should be equal to "1RgE7s-000Bou-TJ ** ..."';

}

done_testing();