use ExtUtils::MakeMaker;

WriteMakefile(
  NAME => 'Smart::Worker',
  VERSION_FROM => 'lib/Smart/Worker.pm',
  EXE_FILES => ['bin/smartworker', 'bin/testworker'],
  PREREQ_PM => {
      'Net::Stomp' => 0,
      'JSON::XS'   => 0,
  }
);

