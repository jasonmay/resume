#!/usr/bin/env perl
package Resume::Template;
use strict;
use warnings;
use Template::Declare::Tags; # defaults to ’HTML’
use base 'Template::Declare';
use List::Util qw/first/;

# made to be an array for the ease of maintaining order
my @sections = (
        [ 
            education => sub {
                my %data = (
                    'University'            => "The Pennsylvania State University",
                    'GPA'                   => '3.40/4.00',
                    'Expected to graduate'  => "Spring 2009",
                    'Status'                => "I am currently on my sixth semester. I currently have one (time consuming) three-credit class. I will not be taking any classes this summer (2008).",
                );

                table {
                    for (keys %data) {
                        row {
                            cell { b { $_ }  }
                            cell { $data{$_} }
                        }
                    }
                }
            }
        ],
        [ 
            experience => sub {
                my  @experience = (
                    [
                        'Penn State York',
                        'Web Developer Intern',
                        '(June 2007 - Present)' =>
                        [
                            "Make updates to the campus Web site",

                            "Work on individual projects for the campus",

                            "Research Web technologies, ".
                            "such as web programming languages, CSS, ".
                            "and MVC frameworks for the Web",
                        ]
                    ],
                    [
                        'Penn State York',
                        'Helpdesk',
                        '(January 2006 - May 2007)' =>
                        [
                            "Solved IT-related problems among the campus"
                        ]
                    ],
                    [
                        'MCTG',
                        'Software Engineer',
                        '(September 2006 - January 2007)' =>
                        [
                            "Developed a large-scale HVAC Web site",
                            "Worked in a team of 9"
                        ]
                    ],
                );

                ul {
                    for (@experience) {
                        li {
                            my ($employer, $title, $era, $tasks) = @$_;
                            em { $employer }            br {}
                            b { $title } small { $era } br {}
                            ul {
                                attr { class is "job" }
                                li { $_ } for @$tasks;
                            }
                        }
                    }
                }
            }
        ],
        [ 
            projects => sub {
                p { "This resume. Duh." }
            }
        ],
        [ 
            skills => sub {
                my @skills = (
                    "Self-motivated",
                    "Learn quickly",
                    "Eat burritos a lot"
                );

                ul {
                    li { $_ } for @skills;
                }
            }
        ],
);

for (@sections) {
    my ($item, $code) = @$_;
    template $item => $code;
}

template section => sub {
    my $self = shift;
    my $section = shift;
    my $item = first { $_->[0] eq $section } @sections;

    div {
        attr {
            class is "header"
        }
        b { uc $section }
    };
    $item->[1]->();
};

template top => sub {
    div { img { attr { src is "top.gif" } } }
};

template wrap => sub {
    html {
        head {
            link { attr { rel is 'stylesheet', href is 'resume.css' } }
        }
        body {
            show 'top';       
            show('section', $_->[0]) for @sections;
        }
    }
};

1;
