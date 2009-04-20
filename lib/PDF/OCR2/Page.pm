package PDF::OCR2::Page;
use strict;
use vars qw($VERSION $DEBUG @TRASH $CHECK_PDF $NO_TRASH_CLEANUP);
use LEOCHARRE::Class2;
__PACKAGE__->make_constructor_init;
__PACKAGE__->make_accessor_setget('errstr');
__PACKAGE__->make_count_for('abs_images');
__PACKAGE__->make_accessor_setget_ondisk_file( 'abs_pdf' );
use Carp;
$VERSION = sprintf "%d.%02d", q$Revision: 1.10 $ =~ /(\d+)/g;

# so it will crash if no abs pdf is passed, or is not on disk
sub init { 
   my $self = shift;
   debug('is on');
   _check_pdf( 
      $self->abs_pdf or croak('missing abs_pdf arg')
   ) if $CHECK_PDF;

}



sub abs_images {
   my $self = shift;
   unless( $self->{abs_images} ){
      my $abs = $self->abs_pdf;

      debug("calling PDF::GetImages for '$abs'.. ");
      require PDF::GetImages;
      my $images = PDF::GetImages::pdfimages($abs);
      defined $images or $self->errsrt("PDF::GetImages::pdfimages($abs) does not return.");
      scalar @$images or $self->errstr("PDF::GetImages::pdfimages($abs) does not return values.. no images?");
      $self->{abs_images} = $images;
      $self->{abs_images} ||= [];
      debug("DEBUG is ON");
   }
   wantarray ? @{$self->{abs_images}} : $self->{abs_images};
}


sub _text_from_pdf {   
   #$_[0]->{_text_from_pdf} ||= $_[0]->_system_pdftotext( $_[0]->abs_pdf );
   $_[0]->{_text_from_pdf} ||= $_[0]->_cam_pdftotext( $_[0]->abs_pdf );

}

sub _text_from_images {
   my $self = shift;

   my $txt;
   for my $abs ( @{$self->abs_images} ){
      $txt.= $self->_text_from_image($abs);
   }
   $txt;
}

sub _length_from_images  { length $_[0]->_text_from_images   || 0 } # will attempt creation of images
sub _length_from_pdf     { length $_[0]->_text_from_pdf      || 0 } # will call pdftotext
sub _length              { length $_[0]->_text               || 0 } # will call all


sub _text_from_image {
   my($self,$abs) = @_;
   unless( $self->{_text_from_image}->{$abs} ){
      
      #   -f $abs ?       print STDERR" ===== $abs is on disk \n" : confess("No $abs on disk");

      require Image::OCR::Tesseract;
      my $txt = Image::OCR::Tesseract::get_ocr($abs);
      $self->{_text_from_image}->{$abs} = $txt;
      push @TRASH, $abs;
   }
   $self->{_text_from_image}->{$abs};
}

sub text {
   my $self = shift;

   unless($self->{text}){
      
      # text from pdf first
      my $txt = $self->_text_from_pdf;
      # check the length now ?
      
      debug( "LENGTH A, from pdf regular text ".length($txt));

      # now text from images
      $txt.= $self->_text_from_images;
      $self->{text} = $txt;

      debug( "LENGTH B, from images/ocr ".length($txt));

   }
   $self->{text};
}









# CAN BE REUSED ................. :

sub debug { $DEBUG ? print STDERR __PACKAGE__." DEBUG @_\n" : 1 }

sub _check_pdf {
   my $abs_pdf = shift;
   require PDF::API2;
	eval { PDF::API2->open($abs_pdf) } || 0;
}


sub _cam_pdftotext {
   my($self,$abs) = @_;
   require CAM::PDF;
   my $o = CAM::PDF->new($abs);
   my $text = $o->getPageText(1); # the whole point is this package does 1 ONE page.
   return $text;
}


# so it can be re used:
sub _system_pdftotext {
   my ($self,$abs) = @_;

   my $bin = `which pdftotext`;
   chomp $bin;
  

   my @cmd = ( $bin, '-q', $abs );

   debug(@cmd);

   my $absout = $abs;
   $absout=~s/\.pdf/.txt/i;

   local $/;
   open(OUT,'<',$absout) or $self->errstr("could not open '$absout' for reading, $!") and return;
   my $t = <OUT>;
   close OUT;
   push @TRASH, $absout;
   $t;
}

sub DESTROY { unlink @TRASH unless ( $DEBUG or $NO_TRASH_CLEANUP ) }


1;









__END__

=pod

=head1 NAME

PDF::OCR2::Page

=head1 DESCRIPTION

Extract a pdf page document's text, from inside the document and if there are images, from the images via
tesseract ocr.


=head1 METHODS

=head2 new()

Arg is hashref. Must have abs_pdf to pdf file.
If no abs_pdf is provided or it does not exist on disk, throws exception.

=head2 abs_pdf()

Argument is path to pdf representing one page.
Must be on disk.
Perl setget method.

=head2 abs_images()

Returns aref of images, returns list in list context.
Uses PDF::GetImages, slow.






=head1 CLASS VARIABLES

Defaults shown.

Eval pdf with PDF::API2 for correctness/etc.

   $PDF::OCR2::Page::CHECK_PDF = 0;

Do not clean up trash when DESTROY

   $PDF::OCR2::Page::NO_TRASH_CLEANUP = 0;

Debug on

   $PDF::OCR2::Page::DEBUG = 0;





=head1 AUTHOR

Leo Charre leocharre at cpan dot org





