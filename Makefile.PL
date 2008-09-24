use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'PDF::OCR2',
   VERSION_FROM => 'lib/PDF/OCR2.pm',


   # gen /usr/bin/pmused by Wed Sep 24 15:42:46 EDT 2008 
   PREREQ_PM => {
      'CAM::PDF'                          => '1.21',
      'Carp'                              => '1.04',
      'Cwd'                               => '3.12',
      'Image::OCR::Tesseract'             => '1.14',
      'LEOCHARRE::Class2'                 => '1.11',
      'LEOCHARRE::DEBUG'                  => '1.11',
      'LEOCHARRE::Dir'                    => '1.02',
      'PDF::API2'                         => '2.015',
      'PDF::Burst'                        => '1.10',
      'PDF::GetImages'                    => '1.01',
      'Smart::Comments'                   => '1.0.2',
      'Test::Simple'                      => '0.8',
   },


   EXE_FILES => [],
);


