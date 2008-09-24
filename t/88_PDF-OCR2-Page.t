use Test::Simple 'no_plan';
use strict;
use lib './lib';
use PDF::OCR2::Page;
use Smart::Comments '###';
$PDF::OCR2::Page::DEBUG = 1;

$PDF::OCR2::Page::CHECK_PDF = 1;


my $abs_pdf = './t/leodocs/hdreceipt.pdf';

my $i = PDF::OCR2::Page->new( { abs_pdf => $abs_pdf });

ok $i, 'instanced' or die;

#ok $i->abs_pdf('./t/leodocs/hdreceipt.pdf'),'abs_pdf';

ok $i->abs_pdf,'abs_pdf()';

ok_part('IMAGES');

ok $i->abs_images, 'abs_images()';

my @imgs = $i->abs_images;

ok( scalar @imgs);

ok $i->abs_images_count == 1;

ok $_,$_ for @imgs;




ok_part('EXTRACTING');
my $firstimg;

ok( $firstimg = $i->_text_from_image($imgs[0]), "_text_from_image() got text out");

#### $firstimg

my $allimgs;
ok $allimgs = $i->_text_from_images, "_text_from_images()";

#### $allimgs

if( my $pdftext = $i->_text_from_pdf ){
   print STDERR "_text_from_pdf yes\n";

   #### $pdftext
}
else {
   print STDERR "_text_from_pdf no\n";
}

my $alltext;
ok $alltext = $i->text, 'text()';


#### $alltext

### @PDF::OCR2::Page::TRASH

ok_part('tuition');

$PDF::OCR2::Page::DEBUG = 1;

my $b = PDF::OCR2::Page->new( { abs_pdf => './t/leodocs/tuition.pdf' });
my $textt= $b->text;

print STDERR "TEXT:\n\n$textt\n";


ok( $textt=~/Heights/, "text out has 'Heights'") or die('cant get normal text out?!');






sub ok_part {
   printf STDERR "\n\n===========================\n%s\n===========================\n\n",uc("@_");
}




