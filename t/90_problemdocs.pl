use Test::Simple 'no_plan';
use strict;
use lib './lib';
use PDF::OCR2;
use LEOCHARRE::Dir 'lsfa';

$PDF::OCR2::DEBUG = 1;
$PDF::OCR2::Page::DEBUG = 1;

my @pdfs = grep { /\.pdf/i } lsfa('./t/problemdocs');

for my $abs (@pdfs){
   print STDERR "\n\n";
   ok( $abs , "$abs");
   my $p;
   ok( $p = PDF::OCR2->new($abs), "instanced") or die;

   my $txt;

   ok( $txt = $p->text, "text()");

   ### $txt

}





