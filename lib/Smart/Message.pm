package Smart::Message;

use strict;
use warnings;

use JSON::XS qw();
use base 'Class::Accessor::Chained';

__PACKAGE__->mk_accessors(qw( method args hostname filename ));

my $json = JSON::XS->new->utf8;

sub new {
  my $class = shift;
  my $self  = {};
  bless $self, $class;
}

sub from_data {
  my $class = shift;
  my $data  = shift;
  my $self  = $class->new;
  foreach my $key ( keys %$data ) {
    my $sub = $self->can($key);
    if ( $sub ) {
      $sub->( $self, $data->{$key} );
    }
  }
  return $self;
}

sub from_json {
  my $class = shift;
  my $jsond = shift;
  if (!$jsond) {
    die "not json";
  }
  my $self = $class->new;
  my $data = $json->decode( $jsond );
  $class->from_data( $data );
}

sub as_data {
  my $self = shift;
  my $mesg = {
	      filename => $self->filename,
	      hostname => $self->hostname,
	      method   => $self->method,
	      args     => $self->args
	     };
  return $mesg;
}

sub as_json {
  my $self = shift;
  return $json->encode( $self->as_data );
}

1;
