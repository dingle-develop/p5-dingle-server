  package dIngle::Server::Segment::dIngle
# ***************************************
; our $VERSION='0.01'
# *******************
; use parent 'dIngle::Server::Segment'

; use dIngle
    
; use File::Basename qw/basename/

; sub dispatch
    { my ($self,$pipe) = @_
    ; $self->log("debug","Create a dIngle object")
    
    # sollte dIngle auch für dynamische Seiten genutzt werden, muss das
    # System weiter angepasst werden / Eventuell sollte auch eine andere Klasse
    # mit teilweise identischem Interface in Betracht gezogen werden.
    # VisStyle VisFile VisModul
    
    ; my $store = $pipe->store()
    ; my $query = $store->get('dIngle::Query')
    
    ; unless($query)
        { $self->log("warn","Found no request object dIngle::Query.")
        ; return undef
        }
        
    ; my @fp = split(/\//, $query->path)
    ; my $style = pop(@fp) || 'nostyle'
    ; my $frmtd = join("/",@fp)
    
    ; my $dingle = dIngle->new
        ( VisStyle     => $style
        , VisFormatdir => $frmtd
        , VisFile      => basename($query->site,".html")
        , VisModul     => $query->db
        )

    ; $dingle->file_init()
    
    ; return $dingle
    }
    
; 1

__END__


