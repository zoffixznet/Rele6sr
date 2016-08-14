#!/usr/bin/env perl6

use lib <
    /home/zoffix/CPANPRC/IRC-Client/lib
    /home/zoffix/services/lib/IRC-Client/lib
    /home/zoffix/CPANPRC/RT-REST-Client/lib
    /home/zoffix/services/lib/RT-REST-Client/lib
    lib
>;

use IRC::Client;
use Rele6sr::IRC::Config;
use Rele6sr::IRC::Plugin::RT;

class Rele6sr::IRC::Info {
    multi method irc-to-me ($ where /^\s* help \s*$/) {
        "It's complicated...";
    }
    multi method irc-to-me ($ where /^\s* source \s*$/) {
        "See: https://github.com/zoffixznet/Rele6sr";
    }

    multi method irc-to-me ($ where /'bot' \s* 'snack'/) {
        'om nom nom nom. Delicious!';
    }

    multi method irc-to-me ($ where /:i 'thanks'/ ) {
        'You are quite welcome, friend!';
    }
}

.run with IRC::Client.new:
    :nick<Rele6sr>,
    :host(%*ENV<RELE6SR_IRC_HOST> // 'irc.freenode.net'),
    :channels( %*ENV<RELE6SR_DEBUG> ?? '#zofbot' !! |<#perl6  #perl6-dev  #zofbot>),
    |(:password(conf<irc-pass>) if conf<irc-pass>),
    :debug,
    :plugins(
        Rele6sr::IRC::Info.new,
        Rele6sr::IRC::Plugin::RT.new(
            report-dir => conf<rt-report-file-dir>,
            user       => conf<rt-user>,
            pass       => conf<rt-pass>,
        ),
    )
