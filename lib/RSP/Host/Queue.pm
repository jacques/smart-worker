package RSP::Host::Queue;

use strict;
use warnings;

use base 'RSP::Host';

sub new {
  my $class = shift;
  my $tx    = shift;
  my $self  = $class->SUPER::new( $tx );
  $self->bootstrap_file( $tx->request->{ file } );
  return $self;
}

sub bootstrap_file {
  my $self = shift;
  if (@_) {
    $self->{bootstrap_file} = shift;
    return $self;
  }
  my $bs_file = File::Spec->catfile( $self->code, $self->{bootstrap_file} );
  return $bs_file;
}

1;
