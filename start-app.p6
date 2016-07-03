#!/usr/bin/env perl6
use File::Find;

constant $IGNORE_RE = rx{
      [   '/'? '.precomp' [ '/' | $ ]   ]
    | [   ^ 'assets/assetpack.db' $    ]
    | [   ^ 'assets/cache/'            ]
};

sub MAIN (
    Str $app = 'bin/app.p6',
    Str :$w = 'lib,bin,templates,public,assets'
) {
    my @watchlist = $w.split: /<!after \\> \,/;
    s/\\\,/,/ for @watchlist;

    say "Attempting to boot up the app";
    my $p = bootup-app $app;
    react {
        whenever watch-recursive(@watchlist.grep: *.IO.e) -> $e {
            say "Change detected [$e.path(), $e.event()]. Restarting app";
            $p.kill;
            $p = bootup-app $app;
        }
    }
}

########

my sub bootup-app ($app) {
    my Proc::Async $p .= new: 'perl6', $app, 'daemon';
    $p.stdout.tap: -> $v { $*OUT.print: $v };
    $p.stderr.tap: -> $v { $*ERR.print: $v };
    $p.start;
    return $p;
}

########

my sub watch-recursive(@dirs) {
    supply {
        my sub watch-it($p) {
	        if ( $p ~~ $IGNORE_RE ) {
                say "Skipping .precomp dir [$p]";
                return;
            }
            say "Starting watch on `$p`";
            whenever IO::Notification.watch-path($p) -> $e {
                if $e.event ~~ FileRenamed && $e.path.IO ~~ :d {
                    watch-it($_) for find-dirs $e.path;
                }
                emit($e);
            }
        }
        watch-it(~$_) for |@dirs.map: { find-dirs $_ };
    }
}

my sub find-dirs (Str:D $p) {
    state $seen = {};
    return slip ($p.IO, slip find :dir($p), :type<dir>).grep: { !$seen{$_}++ };
}
