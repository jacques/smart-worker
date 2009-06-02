package RSP::Extension::QueueWorker;

use strict;
use warnings;

use Smart::Worker;
use Smart::Message;
use base 'RSP::Extension';

sub provides {
  my $class = shift;
  my $tx    = shift;
  return {
	  'queue_execute' => sub {
	    my ( $file, $method, $args ) = @_;
	    my $host = $tx->hostname;
	    my $mesg = Smart::Message->from_data({
						  hostname => $tx->hostname,
						  filename => $file,
						  method   => $method,
						  args     => $args
						 });
	    Smart::Worker->connection->send({
					     destination => '/queue/smart/workers',
					     body        => $mesg->as_json
					    });
	    return 1;
	  }
	 }
}

1;
