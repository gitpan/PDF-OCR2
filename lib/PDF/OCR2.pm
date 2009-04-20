package PDF::OCR2;
use strict;
use PDF::OCR2::Page;
use LEOCHARRE::Class2;
use Carp;
use vars qw($VERSION $DEBUG @TRASH $CHECK_PDF $NO_TRASH_CLEANUP);
__PACKAGE__->make_accessor_setget( 'abs_path', );
__PACKAGE__->make_count_for( '_abs_bursts' );
$VERSION = sprintf "%d.%02d", q$Revision: 1.11 $ =~ /(\d+)/g;

sub debug { $DEBUG or return 1; print STDERR  __PACKAGE__." DEBUG : @_\n"; 1 }


sub new {
   my($class,$arg) = @_;

   # resolve arg
   $arg or croak('missing arg to constructor');
   require Cwd;
   my $self = {
      abs_path => ( Cwd::abs_path($arg) or croak("cant get abs path to '$arg'") )
   };
   bless $self,$class;   

   return $self;
}

sub _abs_bursts {
   my $self = shift;

   unless( $self->{_abs_bursts} ){
      debug('bursting');
      require PDF::Burst;
      my @abs = PDF::Burst::pdf_burst($self->abs_path) or warn('error'); #carp($PDF::Burst::errstr);
      $self->{_abs_bursts} = [@abs]; # even if none returned, now contains aref
      push @TRASH, @abs;      
      debug("@abs");
   }
   
   wantarray and return @{$self->{_abs_bursts}};
   return $self->{_abs_bursts};
}

sub _page { # return page object
   my($self,$pagenum) = @_;
   
   $pagenum=~/\D/ and croak("arg must be page number");
   
   unless( $self->{page}->{$pagenum} ){
      debug("instancing page object page $pagenum");
      my $abs = $self->_abs_bursts->[($pagenum - 1 )] 
         or croak("No such page num: $pagenum");
      debug($abs);
      my $o = 
         PDF::OCR2::Page->new({ abs_pdf => $abs }) 
         or die("Could not instance PDF::OCR2::Page for $abs");
      $self->{page}->{$pagenum} = $o;
   }
   return  $self->{page}->{$pagenum};
}


sub text {
   my $self = shift;

   my @texts;

   debug( " bursts count: ". $self->_abs_bursts_count);

   for my $pagenum ( 1 .. $self->_abs_bursts_count ){
      my $p = $self->_page($pagenum);
      push @texts, $p->text;
   }

   wantarray ? @texts : join( "\f", @texts);
}


sub DESTROY { unlink @TRASH unless ( $DEBUG or $NO_TRASH_CLEANUP ) }


1;




__END__

=pod

=head1 NAME

PDF::OCR2 - extract all text and all image ocr from pdf

=head1 SYNOPSIS

   use PDF::OCR2;

   my $p = PDF::OCR2->new('./path/to/file.pdf');

   my $text_all   = $p->text;
   my @text_pages = $p->text;

=head1 DESCRIPTION

This is meant to replace PDF::OCR.
The backend complexity of this process has been isolated in modules:

   PDF::GetImages
   PDF::Burst
   Image::OCR::Tesseract
   PDF::OCR2::Pages - in this distro.

Why not just modify PDF::OCR??
This is such a massive breakdown of code hierachy and interdependency, and such a different
interface, that this made more sense. 
PDF::OCR was ok. But it was messy and really, this is a lot better.

=head1 METHODS

=head2 new()

Argument is path to pdf file.

=head2 text()

Takes no argument.
In scalar context, returns text of all pages, joined with a pagebreak \f character.
In list context, returns text of pages one per element.

=head1 CAVEATS

This only works on posix.

=head1 ERRORS

If you have errors with PDF::API2 saying the pdf is corrupt, likely via PDF::Burst..
Then try this:

   use PDF::OCR2;

   PDF::Burst::BURST_METHOD = 'CAM_PDF';
   
   # and then...
   my $pdf = PDF::OCR2->new('./pathtofile.pdf');
   print $pdf->text;

=head1 CRIT AND SUGGESTIONS

The AUTHOR is open to any suggestions and requests.

=head1 SEE ALSO

L<CAM::PDF>
L<PDF::API2>
L<PDF::GetImages>
L<PDF::Burst>
L<PDF::OCR2::Page>

=head1 REPLACES

L<PDF::OCR> - deprecated by this module.

=head1 AUTHOR

Leo Charre leocharre at cpan dot org

=head1 THANKS

=over 4

=item Long Nguyen

=back

=head1 COPYRIGHT

Copyright (c) 2009 Leo Charre. All rights reserved.

=head1 LICENSE

This package is free software; you can redistribute it and/or modify it under the same terms as Perl itself, i.e., under the terms of the "Artistic License" or the "GNU General Public License".

=head1 DISCLAIMER

This package is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the "GNU General Public License" for more details.

=cut







