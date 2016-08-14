use IRC::Client;
unit class Rele6sr::IRC::Plugin::RT does IRC::Client::Plugin;
use HTML::Entity;
use RT::REST::Client;

constant $ticket-url = 'https://rt.perl.org/Ticket/Display.html';
constant $report-url = %*ENV<REPORT_URL> // 'http://bug.perl6.party/';
constant $release-date = Date.new: '2016-08-20';
constant $last-release-date = Date.new: '2016-07-16';

has $!rt;
has $!report-dir;

submethod BUILD (:$!report-dir, :$user, :$pass) {
    $!rt = RT::REST::Client.new: :$user, :$pass;
}

multi method irc-addressed (
    $e where /:i ^ \s* 'reminder' \s* $ /
    # {
        # .text ~~ /:i ^ 'reminder' $ /
        # and ( $e.host eq 'unaffiliated/zoffix' or $e.host eq '127.0.0.1' )
    # }
) {
    my $tickets = self!tickets-link;
    my $gitlog  = self!gitlog-link;

    $.irc.send: :where($e.channel), text =>
        "🎺🎺🎺 Friends! I bear good news! Rakudo's release will happen in"
        ~ " just {$release-date - Date.today} days! Please update the ChangeLog"
        ~ " with anything you worked on that should be known to our users. 🎺🎺🎺";

    $.irc.send: :where($e.channel), text =>
        "🎺🎺🎺 Here are still-open new RT tickets since last release: $tickets"
        ~ " And here is the git log output for commits since last"
        ~ " release: $gitlog 🎺🎺🎺";
}

method !tickets-link {
    my @tickets = $!rt.search(
        :after($last-release-date)
    ).map: {%(
        id      => .id,
        subject => .subject,
        tags    => (.tags.list or ['UNTAGGED',]),
    )};

    self!save-ticket-report: @tickets;
}

method !gitlog-link {
    say "Starting to fetch stuff";
    my $log = qqx|git clone https://github.com/rakudo/rakudo /tmp/rakudo 2>&-;
            cd /tmp/rakudo; git pull --rebase;
            git log --since=$last-release-date --reverse;|;

    my @commits = $log.split(/<before 'commit ' \S+ $$ >/).grep(/^'commit'/);

    self!save-gitlog-report: @commits, '/tmp/rakudo/docs/ChangeLog'.IO.slurp;
}

method !save-gitlog-report (@commits, $changelog) {
    my $out = qq:to/HTML/;
        <style> {get-css} </style>
        <h1>{+@commits} Commits</h1>
        <ul id="commits-list">
    HTML
    $out ~= join "\n", @commits.map: &prep-commit;
    $out ~= [~] '</ul><textarea id="changelog">',
                    encode-entities(
                        $changelog.split(/<before ^^ 'New in '>/)[1]
                    ),
                    '</textarea>';

    return self!save-to-file: $out;
}

sub prep-commit ($c) {
    my ($header, $title, $body) = encode-entities($c).split(/\n\s*\n/, 3);
    $title .= trim;
    $body //= '';
    return join "\n",
        '<li>',
        qq{<div class="header">$header\</div>},
        "<h2>$title\</h2>",
        '<div class="commit-body">' ~ $body.subst(:g, "\n", '<br>') ~ '</div>',
        '</li>';
}

method !save-ticket-report (@tickets, :$tag, :$nick = '<anon>') {
    my $css = get-css;

    my $out = qq:to/HTML/;
        <style> $css </style>
        <body>
            <h1>
                {+@tickets} ticket{@tickets > 1 ?? 's' !! ''}
                <small>
                    ({$tag ?? "tagged [$tag]" !! "all tickets"},
                    requested by { encode-entities $nick } at
                    { DateTime.now.Str.split('.')[0].subst('T', ' ') })
                </small>
            </h1>
            <table><tbody>
    HTML

    $out ~= join "\n", @tickets.map: {
        qq:to/HTML/
        <tr>
            <td><a target="_blank"
                href="$ticket-url?id={.<id>}#ticket-history">
                    RT#{.<id>}
                </a></td>
            <td>
                {
                    $tag ?? '' !!
                        '<span class="tags">'
                        ~ encode-entities(.<tags>.map({"[$_]"}).join)
                        ~ '</span>'
                }
                { encode-entities .<subject>                 }
            </td>
        </tr>
        HTML
    };

    $out ~= q:to/HTML/;
        </tbody></table>
    HTML

    return self!save-to-file: $out;
}

method !save-to-file ($out) {
    my $file = time;
    loop {
        my $f = ($!report-dir ~ '/' ~ $file ~ '.html').IO;
        if $f.e {
            $file ~= '_';
            redo;
        }
        $f.IO.spurt: $out;
        last;
    }

    "$report-url$file.html";
}

sub get-css {
    return Q:to/CSS/;
        body {
            width: 1400px;
            margin: 10px auto;
            font: .85em "Trebuchet MS", Arial, Helvetica, sans-serif;
            color: #444;
            opacity: .9;
        }

        table, tr, td {
            border-collapse: collapse;
            border: 1px solid #ccc;
        }

        h1 {
            font-size: 160%;
            text-align: center;
        }

        h1 small { font-weight: normal; }
        table    { width: 100%;         }
        .tags    { color: #999;         }
        td       { padding: 5px 10px;   }
        a        { color: #44a;         }

        #commits-list {
            border-top: 1px solid #999;
            padding-top: 20px;
            padding-left: 0;
            list-style: none;
            float: left;
            width: 700px;
            height: 800px;
            overflow-y: scroll;
            margin-right: 40px;
        }
        #commits-list .header { color: #888; }
        #commits-list h2 {
            font-size: 140%;
            margin-bottom: 10px;
        }
        #commits-list .commit-body { font-size: 120%; }
        #commits-list li {
            border-bottom: 1px solid #999;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }

        #changelog {
            overflow-y: scroll;
            height: 800px;
            width: 660px;
            float: left;
            background: #fafafa;
            padding: 20px;
            border: 1px solid #eee;
        }
    CSS
}
