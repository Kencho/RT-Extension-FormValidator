use strict;
use warnings;

use inc::Module::Install;

author 'Jesús Alonso Abad and others';
license 'MIT';

RTx 'RT-Extension-FormValidator';

requires_rt '4.4.0';

requires 'JSON';
requires 'Try::Tiny';

test_requires 'Test::More';

WriteAll();

1;
