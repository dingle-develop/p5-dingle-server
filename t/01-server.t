
use Test::More tests => 2;

use dIngle::Server;

my $s = dIngle::Server->new({'port' => 9999});


is($s->default_port,8002,'default_port');
is($s->port,9999,'port');
