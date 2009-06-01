use ExtUtils::MakeMaker;

WriteMakefile(
  NAME => 'RSP',
  VERSION_FROM => 'lib/Smart/Worker.pm',
  EXE_FILES => ['bin/smartworker']
  PREREQ_PM => {
      'Net::Stomp' => 0,
      'JSON::XS'   => 0,
  }
);

