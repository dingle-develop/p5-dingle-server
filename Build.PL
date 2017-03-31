#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Module::Build;

my $builder = Module::Build->new(
     module_name => 'dIngle::Server',
     dist_version => '0.1.00',
     dist_author => [
	     'Mike Würfel <sknpp@cpan.org>'
     ],
     license => 'perl',
     dist_abstract => 'a server component for a software generator',
     requires => {
          'perl' => '5.12.0',
          'HTTP::Daemon' => '6.0',
          'Class::Accessor' => '0.34'
     },
     build_requires => {

     }
);

$builder->create_build_script();
