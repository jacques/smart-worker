package RSP::Transaction::Queue;

use strict;
use warnings;
use Smart::Message;
use base 'RSP::Transaction';

## basically, we don't want to do anything here.
sub run {}

sub hostname {
  my $self = shift;
  if (@_) {
    $self->{hostname} = shift;
    return $self;
  }
  return $self->{hostname};
}

sub callback {
  return \&queue_callback;
}

sub queue_callback {
  my ($conn, $frame) = @_;
  my $mesg = Smart::Message->from_json( $frame->body );

  __PACKAGE__->process_message( $mesg );
}

sub process_message {
  my $class = shift;
  my $mesg  = shift;
  my $tx = RSP::Transaction::Queue->new();
  my $request = { file => $mesg->filename };
  my $response = {};
  $tx->request( $request );
  $tx->response( $response );
  $tx->hostname( $mesg->hostname );
  $tx->bootstrap;
  $tx->context->call( $mesg->method, @{ $mesg->args } );
  $tx->end;

}

1;
