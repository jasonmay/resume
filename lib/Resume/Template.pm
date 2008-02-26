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
        skills => sub {
            my @skills = (
            [
                q{Programming} => sub {
                    ul {
                        li { "Perl (Jifty, DBI, Test-driven Development)" }
                        li { "Ruby on Rails (Test-driven Development)" }
                        li { "Java (Servlets, JSP, Database, Networking)" }
                        li { "PHP (CakePHP, Drupal)" }
                    }
                }
            ],
            [
                q{Tools} => sub {
                    ul {
                        li { "Editing: Vim, Dreamweaver, Eclipse (original, Aptana), Netbeans, GIMP, Photoshop" }
                        li { "Utilities: Apache, Bash" }
                        li { "SCM: Subversion, darcs" }
                        li { "Database: PostgreSQL, MySQL" }
                        li { "Misc: XML, YAML" }
                    }
                }
            ],
            [
                q{Operating Systems} => sub {
                    ul {
                        li {
                            "*nix: ".
                            "Gentoo 2007.0, Debian (Etch, Lenny), FreeBSD 6.2" }
                    }
                }
            ],
            );

            for (@skills) {
                my ($topic, $code) = @$_;
                p {
                    b { $topic } br {};
                    $code->();
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
                my @projects = (
                {
                    name  => 'This resume',
                    url   => "http://j.asonmay.net/".
                            "darcsweb/index.cgi?r=Resume;a=tree",
                    tasks => [
                        'Made with a Perl templating module: Template::Declare',
                        'Currently in development'
                    ]
                },
                {
                    name => 'Photos',
                    url  => "http://j.asonmay.net/".
                            "darcsweb/index.cgi?r=Photos;a=tree",
                    tasks => [
                        'Made in Jifty, a Web app builder in Perl',
                        'Being developed for fun',
                        'Currently in development'
                    ]
                },
                {
                    name => 'Dataninja Interface',
                    url  => "http://j.asonmay.net/".
                            "darcsweb/index.cgi?r=Dataninja;a=tree",
                    tasks => [
                        'Interface for a logging bot on Internet Relay Chat',
                        'Being developed for fun',
                        'Currently in development'
                    ]
                },
                {
                    name => 'IST 440W CMS',
                    tasks => [
                        'CMS that is being made in Ruby on Rails',
                        'Utilizing the agile methodology',
                        'Assigned to be the scrum master of the development team',
                        'Working in a team of eight developers',
                        'Currently in development'
                    ]
                },
                {
                    name => 'York County Archives',
                    tasks => [
                        'Archiving system powered by Java Servlets',
                        'Involved hundreds of thousands of rows in databases',
                    ]
                }
                );

                ul {
                    for my $project (@projects) {
                        li {
                            if (exists $project->{url}) {
                                a {
                                    attr { href is $project->{url} }
                                    $project->{name}
                                }
                            }
                            else {
                                span {
                                    attr { style is "color: #008" }
                                    $project->{name}
                                }
                            }
                            ul {
                                li { $_ } for @{$project->{tasks}};
                            }
                        }
                    }
                }
            }
        ],
        [
            interests => sub {
                my @interests = (
                [
                    q{Conferences and Workshops} => sub {
                        ul {
                            li { "Frozen Perl 2008" }
                            li { "Harrisburg Ruby Group meetups" }
                            li { "Harrisburg Linux User Group meetups" }
                        }
                    }
                ],
                );

                for (@interests) {
                    my ($topic, $code) = @$_;
                    p {
                        b { $topic } br {};
                        $code->();
                    }
                }
            }
        ]
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
        big { uc $section }
    };
    $item->[1]->();
};

template top => sub {
    div { img { attr { src is "top.gif" } } }
};

template footer => sub {
    p { em { small { "Resume was last generated: " . localtime } } }
};

template wrap => sub {
    html {
        head {
            link { attr { rel is 'stylesheet', href is 'resume.css' } }
        }
        body {
            show 'top';       
            show('section', $_->[0]) for @sections;
            show 'footer';
        }
    }
};

1;
