#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";

=pod

=encoding UTF-8

=head1 DESRIPTION

Импорт почтового лога в базу данных

=head1 SYNOPSYS

Пример использвования

    ./import.pl -f file -dsn dbi:DriverName:database=database_name;host=hostname;port=port -u db_user -p db_password

Параметры скрипта

  -f, --file     - имя импортируемого файла
  -d, --dsn      - параметры подключения к базе данных
  -u, --user     - имя пользователя для подключения к базе данных
  -p, --pass     - пароль для подключения к базе данных
  -v, --verbose  - вывод сообщений о прогрессе
  -h, --help     - вывод помощи

=cut

use IncomingMessage;
use DelayedMessage;
use UndeliveredMessage;
use DeliveredMessage;
use AdditionalMessage;
use InfoMessage;

use Storage ();

use Getopt::Long;
use Pod::Usage;
use File::Slurp;
use DBI;
use DateTime;

&main();

sub main {
        my %opts = cmd_options();

        dbg( $opts{ 'verbose' }, 'Starting to work' );

        my $dbh = DBI -> connect(
                $opts{ 'dsn' },
                $opts{ 'user' },
                $opts{ 'pass' },
                { RaiseError => 1 }
        );

        map { save( dbh => $dbh, str => $_, verbose => $opts{ 'verbose' } ) } read_file( $opts{ 'file' } );

        $dbh -> disconnect();

        dbg( $opts{ 'verbose' }, 'Job is done' );
}

sub cmd_options {
        my %options = ();

        my @profile = (
                "file=s",
                "dsn=s",
                "user=s",
                "pass=s",
                "verbose=s",
                'help|?'
        );

        GetOptions( \%options, @profile ) or pod2usage(2);

        if( $options{ 'help' } ) { pod2usage( -exitval => 0, -verbose => 2 ); }

        if( !$options{ 'file' } ) {
                my $warning = "Укажите путь к файлу почтового лога\n\n Например: \n ./$0 -f ./mailog";

                pod2usage( -message => $warning );
        }

        if( not( -e $options{ 'file' } ) ) {
                my $warning = sprintf "Файл %s не найден. Укажите путь к файлу лога для обработки", $options{ 'file' };

                pod2usage( -message => $warning );
        }

        if( not( -r $options{ 'file' } ) ) {
                my $warning = sprintf "Файл %s не доступен для чтения под текущим пользователем", $options{ 'file' };

                pod2usage( -message => $warning );
        }

        if( !($options{ 'dsn' } && $options{ 'user' } && $options{ 'pass' } ) ) {
                my $warning = "Укажите настройки для подключения к базе данных\n\n Например: \n ./$0 -u user -p pass -d dbi:Pg:dbname=[databasename];host=[hostname];port=[port]";

                pod2usage( -message => $warning );
        }

        return %options;
}

sub save {
        my ( %params ) = @_;

        my $dbh     = $params{ 'dbh' };
        my $str     = $params{ 'str' };
        my $verbose = $params{ 'verbose' };

        dbg( $verbose, sprintf "Process '%s'", $str );

        Storage::store( $dbh, from_str( $str ) );

        dbg( $verbose, " --> Done\n" );

        return;
}

sub from_str {
        my ( $str ) = @_;

        my @scanners = qw(
                IncomingMessage
                DelayedMessage
                UndeliveredMessage
                DeliveredMessage
                AdditionalMessage
                InfoMessage
        );

        foreach my $scanner ( @scanners ) {
                if( my $message = $scanner -> from_str( $str ) ) {
                        return $message;
                }
        }

        dbg( 1,  sprintf "Cant parse string '%s'", $str );

        return;
}

sub dbg {
        my ( $verbose, $message ) = @_;

        if( $verbose ) {
                printf "%s %s\n", DateTime -> now(), $message;
        }

        return;
}

