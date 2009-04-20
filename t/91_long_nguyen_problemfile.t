use Test::Simple 'no_plan';
use strict;
use lib './lib';
use PDF::OCR2;
use Cwd;
use vars qw($_part $cwd);
$cwd = cwd();


$PDF::Burst::BURST_METHOD='CAM_PDF';
my $rel = './t/problemdocs/long_nguyen_problemfile.pdf';

my $pdf;
ok( $pdf = PDF::OCR2->new($rel),'new()');

ok( $pdf->text ,'text works');

print STDERR "TEXT IS:\n\n\n" . $pdf->text;










sub ok_part {
   printf STDERR "\n\n===================\nPART %s %s\n==================\n\n",
      $_part++, "@_";
}


