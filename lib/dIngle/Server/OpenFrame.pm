  package dIngle::Server::OpenFrame
# *********************************
; our $VERSION='0.01'
# *******************
; use strict; use warnings; use utf8
; use base 'dIngle::Server'

; __PACKAGE__->mk_accessors('pipeline','_shutdown','_child')

; use POSIX
; use OpenFrame
; use Pipeline

; use OpenFrame::Segment::HTTP::Request

; sub request_class { 'OpenFrame::Segment::HTTP::Request' }

; sub storage_class { 'Pipeline::Store::Simple' }

; sub response_key  { 'HTTP::Response' }

; sub init
    { my ($self,%args)=@_;
    ; $self->pipeline(new Pipeline)
    ; $self->pipeline->store($self->storage_class->new())
    ; my $request = $self->request_class->new()
    ; $self->pipeline->add_segment($request)
    ; $self
    }

; sub run
    { my ($self)=@_
    ; local $@
    ; my $pipeline = $self->pipeline
    ; $self->_shutdown(0)
    ; while((my $c = $self->server->accept()) && !($self->_shutdown))
        { while(my $r = $c->get_request)
            { my $store = $self->storage_class()->new

            ; my @r = $store->can('key_set') ? ('Request' => $r) : ($r)

            ; $pipeline->store( $store->set(@r) )

            ; eval { $pipeline->dispatch() }
	        ; if($@)
	            { warn $@->stacktrace if ref $@
                ; die $@
                }
            ; my $response = $pipeline->store->get($self->response_key)
            ; $c->send_response( $response )
            }
        }
    }

; sub run_forked
    { my ($self) = @_
    ; my $pid = fork()
    ; Carp::croak("Can not fork: $!") unless defined $pid

    ; unless($pid)
        { $SIG{'KILL'} = sub { $self->shutdown }
        ; $self->run
        ; exit(0)
        }        
      else
        { $self->_child($pid)
        }
    ; return 1
    }

; sub shutdown
   { my ($self) = @_
   ; if($self->_child)
       { kill 9, $self->_child
       ; warn $!
       }
   ; $self->_shutdown(1)
   }

; 1

__END__


  01: use strict;
  02: use warnings;
  03:
  04: use Pipeline;
  05: use HTTP::Daemon;
  06: use OpenFrame::Segment::HTTP::Request;
  07: use OpenFrame::Segment::ContentLoader;
  08:
  09: my $d = HTTP::Daemon->new( LocalPort => '8080', Reuse => 1);
  10: die $! unless $d;
  11:
  12: print "server running at http://localhost:8080/\n";
  13:
  14: my $pipeline = Pipeline->new();
  15:
  16: my $hr = OpenFrame::Segment::HTTP::Request->new();
  17: my $cl = OpenFrame::Segment::ContentLoader->new()
  18:                                        ->directory("./webpages");
  19:
  20:
  21: $pipeline->add_segment( $hr, $cl );
  22:
  23:
  24: while(my $c = $d->accept()) {
  25:
  26:   while(my $r = $c->get_request) {
  27:
  28:     my $store = Pipeline::Store::Simple->new();
  29:
  30:
  31:     $pipeline->store( $store->set( $r ) );
  32:
  33:
  34:     $pipeline->dispatch();
  35:
  36:
  37:     my $response = $pipeline->store->get('HTTP::Response');
  38:
  39:
  40:     $c->send_response( $response );
  41:   }
  42: }
