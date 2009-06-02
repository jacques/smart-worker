package RSP::Extension::QueueWorker;

use strict;
use warnings;

use Smart::Worker;
use Smart::Message;
use base 'RSP::Extension';

sub provides {
  print "building queueworker extension\n";
  my $class = shift;
  my $tx    = shift;
  return {
	  'queue_execute' => sub {
	    print "in queueworker extensions...\n";
	    my ( $file, $method, $args ) = @_;
	    my $host = $tx->hostname;
	    my $mesg = Smart::Message->from_data({
						  hostname => $tx->hostname,
						  filename => $file,
						  method   => $method,
						  args     => $args
						 });
	    print "Sending message ", $mesg->as_json, "\n";
	    eval {
	      Smart::Worker->connection->send({
					       destination => '/queue/smart/workers',
					       body        => $mesg->as_json
					      });
	    };
	    if ($@) {
	      warn $@;
	    }
	    print "message sent\n";
	    return 1;
	  }
	 }
}

1;
