use Test::Simple 'no_plan';
use strict;

my @trash = split( /\n/, `find ./t/leodocs -type f -name "*_page_*"`);

scalar @trash;

for my $trash (@trash){
   print STDERR "junking $trash\n";
}
unlink @trash;

ok 1, 'cleaned';

`rm -rf ./t/problemdocs/*.txt ./t/problemdocs/*.tif ./t/problemdocs/*_page_*.pdf`;


if( my @trash2 = split( /\n/, `find ./t/leodocs -type f -name "*.pbm"`) ){
   unlink @trash2;
}
if ( my @trash2 = split( /\n/, `find ./t/leodocs -type f -name "*.ppm"`) ){
   unlink @trash2;
}


