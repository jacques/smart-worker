package RSP::Extension::LocalWorker;

use strict;
use warnings;

use base 'RSP::Extension';
use RSP::Host::Queue;
use RSP::Transaction::Queue;

sub provides {
  my $class = shift;
  my $tx    = shift;
  return {
	  'queue_execute' => sub {
	    my ( $file, $method, $args ) = @_;

	    my $mesg = Smart::Message->from_data({
						  hostname => $tx->hostname,
						  filename => $file,
						  method   => $method,
						  args     => $args
						 });
	    if ( !fork() ) {
	      local $RSP::Transaction::HOST_CLASS = "RSP::Host::Queue";
	      RSP::Transaction::Queue->process_message( $mesg );
	      exit;
	    }
	  }
	 };
}

1;

