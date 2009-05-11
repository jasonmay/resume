#!/usr/bin/env perl
package Resume;
use strict;
use warnings;
use Template::Declare;
use Resume::Template;
Template::Declare->init(roots => ['Resume::Template']);

our $VERSION = '0.01';

sub generate {
    print Template::Declare->show('wrap');
}

1;
