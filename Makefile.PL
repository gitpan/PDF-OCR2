use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'PDF::OCR2',
   VERSION_FROM => 'lib/PDF/OCR2.pm',
   

   # gen /usr/bin/pmused by Mon Apr 20 23:05:00 EDT 2009 
   PREREQ_PM => {
      'CAM::PDF'                          => '1.50',
      'Carp'                              => '1',
      'Cwd'                               => '3',
      'File::PathInfo::Ext'               => '1.27',
      'Image::OCR::Tesseract'             => '1.20',
      'LEOCHARRE::CLI2'                   => '1.04',
      'LEOCHARRE::Class2'                 => '1.13',
      'LEOCHARRE::Dir'                    => '1.06',
      'PDF::API2'                         => '2.015',
      'PDF::Burst'                        => '1.10',
      'PDF::GetImages'                    => '1.10',
      'Smart::Comments'                   => '1',
      'Test::Simple'                      => '0',
   },

   
   LICENSE => 'perl',
   
   
   
   EXE_FILES => [qw(bin/pdfocrtest)],
);


