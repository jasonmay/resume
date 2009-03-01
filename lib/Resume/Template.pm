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
                    'University'           => "Pennsylvania State University",
                    'GPA'                  => '3.47/4.00',
                    'Expected to graduate' => "Summer/Fall 2009",
                    'Status'               => q{I am taking three classes this spring. I have <strong>three classes left</strong>, and I plan to finish them at night (starting May) and work full-time in the day.},
                );

                table {
                    for (keys %data) {
                        row {
                            cell { b { $_ }  }
                            cell { outs_raw $data{$_} }
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
                        li { "Ruby on Rails" }
                        li { "Java (Servlets, JSP, Database, Networking)" }
                        li { "PHP (CakePHP, Drupal)" }
                        li { "JavaScript (jQuery)" }
                    }
                }
            ],
            [
                q{Tools} => sub {
                    ul {
                        li { "Editing: Vim, Dreamweaver, Eclipse (original, Aptana), Netbeans, GIMP, Photoshop" }
                        li { "Utilities: Apache, FastCGI, Bourne Shell" }
                        li { "Networking: IPTables, BIND 9, PF" }
                        li { "SCM: Subversion, darcs, git" }
                        li { "Database: PostgreSQL, MySQL, SQLite" }
                        li { "Tracking: AgileTrack, RT" }
                        li { "Misc: XML, YAML" }
                    }
                }
            ],
            [
                q{Operating Systems} => sub {
                    ul {
                        li {
                            "*nix: ".
                            "Gentoo 2007.0, Debian (Etch, Lenny), Ubuntu, FreeBSD 6.x, OpenBSD 4.x, OS X (Leopard)" }
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
#                    url   => "http://j.asonmay.net/".
#                            "darcsweb/index.py?r=Resume;a=tree",
                    tasks => [
                        'Made with a Perl templating module: Template::Declare',
                        'Currently in development'
                    ]
                },
                {
                    name => 'Photos',
#                    url  => "http://j.asonmay.net/".
#                            "darcsweb/index.py?r=Photos;a=tree",
                    tasks => [
                        'Made in Jifty, a Web app builder in Perl',
                        'Being developed for fun',
                        'Currently in development'
                    ]
                },
                {
                    name => 'Dataninja Interface',
                    url  => "http://github.com/jasonmay/dataninja/tree/master",
                    tasks => [
                        'Interface for a logging bot on Internet Relay Chat',
                        'Being developed for fun',
                        'Currently in development'
                    ]
                },
                {
                    name => 'Ruby on Rails CMS for my Capstone Class',
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
                },
                {
                    name => 'PSU WebAccess System Kit',
                    tasks => [
                        'Small kit used for providing Penn State student authentication',
                        'Aimed to be a drop-in bundle for Apache',
                    ]
                }
                );

                ul {
                    for my $project (@projects) {
                        li {
                            if (exists $project->{url}) {
                                outs $project->{name} . ' - ';
                                small {
                                    a {
                                        attr { href is $project->{url} }
                                        'repository'
                                    }
                                }
                            }
                            else {
                                span {
                                    attr { style is "color: #000" }
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
                            li { "YAPC::NA 2008" }
                            li { "Frozen Perl 2008" }
                            li { "Harrisburg Ruby Group meetups" }
                            li { "Harrisburg Linux User Group meetups" }
                        }
                    }
                ],
                [
                    q{Hobbies} => sub {
                        ul {
                            li { "Traveling" }
                            li { "Tinkering with technology" }
                            li { "IRC" }
                        }
                    }
                ]
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
