  package dIngle::Server::Segment::Query
# **************************************
; our $VERSION='0.01'
# *******************
; use strict; use warnings
; use base 'dIngle::Server::Segment'

; use dIngle::Query

; use Data::Dumper
;
=head1 NAME

dIngle::Server::Segment::dIngle::Query

=head1 DESCRIPTION

Das Modul sollte aus der aufgerufenen Url ein gültiges dIngle::Query
Objekt erzeugen, das entweder direkt oder über den Umweg eines dIngle
Format Hashs zur Erstellung des dynamischen dIngle Objektes dient.

Für die Zukunft sollte das Modul nur die Art der Url bestimmen und dann 
die Aufgabe an das entsprechende Plugin delegieren. Für den Anfang lege ich 
die Art aber erstmal fest. Sie orientiert sich an dem normalen Filemaker
WebCompanion Aufruf.

    -DB => Modul
    -Lay => Bisher ohne Funktion
    
Beim Laden kann der Parameter as_cgi übergeben werden, dann wird zusätzlich
dem dIngle::Query Objekt auch ein CGI Objekt in der Pipeline abgelegt.

Dieses wird nicht automatisch mit dem dIngle::Query Objekt synchronisiert.
Sollten einmal komplexe Applikationen mit diesen Modulen gebaut werden, ist
eine solche Synchronisation im Hintergrund aber empfehlenswert.

=cut

; sub init
    { my $self = shift
    ; my %args = @_
    ; $self->{'as_cgi'} = delete($args{'as_cgi'})
    ; $self->SUPER::init( %args )
    }


; sub dispatch
    { my ($self,$pipe) = @_
    ; $self->log("debug","Start dIngle::Query")
        
    ; my $store = $pipe->store()
    ; my $req
    ; unless( $req = $store->get('OpenFrame::Request') )
        { $self->log("warn","No  Object found for ".ref $self.".")
        ; return undef
        }
        
    ; my $query = $self->create_query_from_or($req)
    ; if($self->{'as_cgi'})
        { return ($query,$query->as_cgi) }
      else
        { return $query }
    }
    
; sub create_query_from_or
    { my ($self,$oreq) = @_

    ; my %temp  = %{$oreq->arguments}
    
    # Remember to split Lists at \0 !!!
    ; my %param = map  { (lc($_) => $temp{$_}) } 
                  grep { /^\-/ } keys %temp
    
    ; my %query
    # Simple parameter
    ; $query{'db'}     = $param{'-db'}     || 'DEFAULT_MODULE'
    ; $query{'layout'} = $param{'-layout'} || 'DEFAULT_LAYOUT'
    ; $query{'script'} = $param{'-script'} if $param{'-script'}
    ; $query{'recid'}  = $param{'-recid'}  if $param{'-recid'}
    
    # Format and error site
    ; my $format       = $param{'-format'} || 'DEFAULT_FORMAT'
    ; my @fp = split /\//, $format
    ; $query{'site'}  = pop @fp
    ; $query{'path'}  = join('/', @fp)
    ; $query{'path'} .= '/' if $query{'path'}
    
    ; if( $format = $param{'-error'} )
        { @fp = split /\//, $format
        ; $query{'error'} = pop @fp
        }
        
    # action parameter 
    ; my @actions = qw/-find -findall -findany -new -edit -delete -view/
    ; for ( @actions )
        { if( exists $param{$_} )
            { $query{'action'} = $_
            }
        }
    ; $query{'action'} = '-view' unless $query{'action'}
    
    # param fuellen => durch das konvertieren in ein CGI Objekt ist auch die 
    # Reihenfolge pfutsch => TODO Query ohne CGI
    ; my @param
    ; for my $pk ( keys %temp )
        { next if $pk =~ /^\-/
        ; if( ref $temp{$pk} eq 'ARRAY' )
            { for ( @{$temp{$pk}} )
                { push @param , $pk => $_
                }
            }
          else
            { push @param , $pk => $temp{$pk}
            }
        }
    ; $query{'param'} = \@param
    
    ; return new dIngle::Query::(%query)
    }

; 1

__END__
