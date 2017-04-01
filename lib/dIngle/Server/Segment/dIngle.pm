  package dIngle::Server::Segment::dIngle
# ***************************************
; our $VERSION='0.01'
# *******************
; use base 'dIngle::Server::Segment'

; BEGIN
    { use dIngle
    ; $dIngle::LOGGING    = 'Log::Log4Perl'
    }
    
; use File::Basename qw/basename/

; sub init
    { my $self = shift
    ; my %args = @_
    ; my @init = delete($args{'module'})
    ; dIngle->init(@init)
 
    ; $self->SUPER::init( %args )
    }

# Die Struktur mit der globalen Chest ist nur beding geeignet.
# Was passiert wenn mehrere Module parallel genutzt werden sollen...
# Für diesen Anwendungsfall ist dIngle eben eigentlich nicht konzipiert.

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
        { $self->log("warn","Kein Requestobjekt vorhanden?")
        ; return undef
        }
        
    ; my @fp = split(/\//, $query->path)
    ; my $style = pop(@fp) || 'nostyle'
    ; my $frmtd = join("/",@fp)
    
    ; my $dingle = new dIngle
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


