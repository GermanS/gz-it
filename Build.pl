use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
        dist_name       => 'gz-it',
        dist_version    => '2025.04.07',
        dist_abstract   => 'Modules for gz it',
        dist_author     => 'GermanS',
        module_name             => 'GZIT',
        recursive_test_files    => 1,
        requires        => {
                'Moose'        => 0,
                'Getopt::Long' => 0,
                'Pod::Usage'   => 0,
                'File::Slurp'  => 0,
                'DBI'          => 0,
                'DateTime'     => 0,
                'Dancer2'      => 0,
                'Dancer2::Plugin::Database' => 0,
        }
);
$build -> create_build_script();
