#!/usr/bin/env perl
package Resume;
use strict;
use warnings;
use Template::Declare;
use Resume::Template;
Template::Declare->init(roots => ['Resume::Template']);

#sub new {
#    bless {}, shift;
#}

sub generate {
    print Template::Declare->show('wrap');
}

1;
