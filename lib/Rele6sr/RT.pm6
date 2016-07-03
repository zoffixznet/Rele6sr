unit class Rele6sr::RT;
use HTTP::UserAgent;
use URI::Escape;

constant $Ticket-URL = 'https://rt.perl.org/Ticket/Display.html?id=';

has Str $.user;
has Str $.pass;
has Str $!credentials = "user=$!user&pass=$!pass";
has Str $.server = 'https://rt.perl.org/REST/1.0';
has $.ua = HTTP::UserAgent.new;

my grammar Tickets {
    rule TOP { <header> [<ticket> ]+ }
    token header { 'RT/' [\d+]**3 % '.' \s+ '200 Ok' }
    token ticket { $<id>=\d+ ':' <.ws> <tag>* <.ws> $<subject>=\N+ }
    token tag { '[' ~ ']' \w+ }
}

my class Ticket {
    has $.id;
    has $.tags;
    has $.subject;
    has $.url;
}

my class TicketsActions {
    method TOP ($/) {
        my @tickets;
        # say $<ticket>;
        for $<ticket> -> $ticket {
            @tickets.push: Ticket.new:
                id       => +.<id>,
                tags     => .<tag>.join(' '),
                subject  => ~.<subject>,
                url      => $Ticket-URL ~ +.<id> ~ '#ticket-history',
            given $ticket;
        }
        make @tickets;
    }
}

method search {
    my $url = "$!server/search/ticket?$!credentials&orderby=-Created"
        ~ "&query=" ~ uri-escape("Queue = 'perl6' AND (Created > '2016-06-18'"
        ~ " AND Status != 'resolved' AND Status != 'rejected')");

    my $s = $.ua.get: $url;
    return $s.status-line unless $s.is-success;
    Tickets.parse($s.content, :actions(TicketsActions)).made;
}
