  package dIngle::Server::Segment
# **********************************
; our $VERSION='0.01'
# *******************
; use strict; use warnings; use utf8
; use parent qw ( Pipeline::Segment OpenFrame::Object )

; use OpenFrame::Response

=head1 NAME

dIngle::Server::Segment

=head1 DESCRIPTION

Basisklasse für die in dIngle verwendeten OpenFrame Segmente.

=head2 log

Einfache Logmethode, als Parameter wird das Level als string und die
Logmeldung übergeben. Ausgabe erfolgt zur Zeit nur auf STDERR.

=cut

# dummy methode
; sub log
    { my ($self,$lvl,@msg) = @_
    ; print STDERR "$lvl => @msg\n" 
    }

=head2 send_pong

Erzeugt eine Response der nur den Zweck anzuzeigen, dass die Pipeline 
ohne anderes Ergebnis abgearbeitet wurde. Nicht zu verwechseln mit der 
default Seite.

=cut

; sub send_pong
    { my $response = OpenFrame::Response->new() 
    
    ; $response->message('pong')
    ; $response->code( ofOK )
    ; $response->mimetype("text/plain")
    ; $response
    }
    
; sub handle_exception
    { my ($self,$e)=@_
    ; if( UNIVERSAL::isa($e,'dIngle::Error') )
        { return $e
        }
      elsif( ref $e ) # oops, unknown exception object
        { return $self->error()->new
            ( msgid => 'Unknown error.'
            , dbginfo => Dumper($e)
            )
        }
      else
        { return $self->error()->new
            ( msgid => 'Error message: [_1]'
            , args  => [$e]
            )
        }
    }
    
; 1

__END__


