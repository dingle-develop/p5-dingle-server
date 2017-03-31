  package dIngle::Server
# **********************
; our $VERSION='0.01'
# *******************
; use strict; use warnings; use utf8

; use base qw(Class::Accessor::Fast)

; sub server_class { 'HTTP::Daemon' }
; sub server_name  { 'Basic HTTP Server' }
; sub default_port { 8002 }

; __PACKAGE__->mk_accessors('server','port')

; sub create
    { my ($self,%args)=@_
    ; $args{'port'} ||= $self->default_port
    ; my $serv = $self->create_server(\%args)
    ; die "No server created: $!\n" unless $serv
    ; $self->new({'server' => $serv,'port' => $args{'port'}})->init(%args)
    }

; sub create_server
    { my ($self,$args)=@_
    ; $self->load_server_class
    ; $self->set_server_args($args)
    ; my $port = $args->{'port'}
    ; my $serv = $self->server_class->new(LocalPort => $port, %$args)
    ; $serv
    }

; sub load_server_class
    { my $self = shift
    ; my $code = "require ".$self->server_class
    ; eval($code) or die "Could not load server class ".$self->server_class."."
    }

; sub set_server_args
    { my ($self,$args)=@_
    ; $self;
    }

; sub init { shift; }

; sub print_listening
   { print $_[0]->server_name
           , " listening at localhost:" . $_[0]->port ."\n"
   }

; 1

__END__
