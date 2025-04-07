use strict;
use warnings;

use Test::More;

use_ok 'InfoMessage';

{
        my $str = '2012-02-13 15:11:45 1RwtmW-000MsX-Aw Completed';

        my $msg = InfoMessage -> from_str( $str );

        isa_ok $msg, 'InfoMessage';

        ok !$msg -> email()
                => 'email is empty';

        is $msg -> info() -> created(), '2012-02-13 15:11:45'
                => 'created should be equal to "2012-02-13 15:11:45"';

        is $msg -> info() -> int_id(), '1RwtmW-000MsX-Aw'
                => 'int_id should be equal to "1RwtmW-000MsX-Aw"';

        is $msg -> info() -> str_without_dt(), '1RwtmW-000MsX-Aw Completed',
                => 'info should be equal to "1RwtmW-000MsX-Aw Completed"';
}

{
        my $str = '2012-02-13 15:11:46 1RviIY-0002QL-6i Spool file is locked (another process is handling this message)';

        my $msg = InfoMessage -> from_str( $str );

        isa_ok $msg, 'InfoMessage';

        ok !$msg -> email()
                => 'Who is on duty today? Email is absent today';

        is $msg -> info() -> created(), '2012-02-13 15:11:46'
                => 'created should be equal to "2012-02-13 14:40:05"';

        is $msg -> info() -> int_id(), '1RviIY-0002QL-6i'
                => 'int_id should be equal to "1RviIY-0002QL-6i"';

        is $msg -> info() -> str_without_dt(), '1RviIY-0002QL-6i Spool file is locked (another process is handling this message)',
                => 'info should be equal to "1RviIY-0002QL-6i Spool ..."';
}

done_testing();


