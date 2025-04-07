package SharedPart;

use strict;
use warnings;

use Moose;

has 'created' => ( is => 'rw', isa => 'Str', required => 1 );
has 'int_id'  => ( is => 'rw', isa => 'Str', required => 1 );

has 'str'     => ( is => 'rw', isa => 'Str', required => 1 );

sub str_without_dt {
        my ( $self ) = @_;

        return substr $self -> str(), length( $self -> created() ) + 1;
}

__PACKAGE__ -> meta() -> make_immutable();

1;

__END__