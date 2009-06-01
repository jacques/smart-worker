package Smart::Worker;

use strict;
use warnings;

our $VERSION = '1.00';

use Net::Stomp;

my $STOMP;

sub run {
  my $class = shift;
  my $cb    = shift;
  my $conn  = $class->connection;
  foreach my $channel (@_) {
    $conn->subscribe({
		      destination => $channel,
		      ack         => 'client',
		     });
  }
  while (1) {
    my $frame = $conn->receive_frame;
    eval {
      $cb->( $conn, $frame );
    };
    if (!$@) {
      $conn->ack( { frame => $frame } );
    } else {
      print "error in callback: $@";
    }
  }
}

sub connection {
  my $class = shift;
  if ( !$STOMP ) {
    $STOMP = Net::Stomp->new({ hostname => 'localhost', port => '61613' });
    $STOMP->connect({ login => 'guest', passcode => 'guest' });
  }
  return $STOMP;
}

1;
