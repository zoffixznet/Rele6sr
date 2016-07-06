# Rele6sr

Rakudo Perl 6 Compiler Release Tool

## OS Support

This software is developed to work on Debian Linux (and it's derivatives,
Ubuntu, Bodhi Linux, etc.). It may work on other OSes, but no official
support is provided.

You can run [Debian](https://www.debian.org/distrib/)
in a [Virtual Box](https://www.virtualbox.org/wiki/Downloads). After a clean
install, run:

    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y install build-essential git curl
    \curl -L https://install.perlbrew.pl | bash
    git clone https://github.com/tadzik/rakudobrew ~/.rakudobrew
    echo 'source ~/perl5/perlbrew/etc/bashrc' >> ~/.bashrc
    echo 'export PATH=~/.rakudobrew/bin:~/.rakudobrew/moar-nom/install/share/perl6/site/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    perlbrew install perl-stable -Duseshrplib -Dusemultiplicity
    perlbrew switch perl-stable # replace perl-stable which version installed in the above step
    perlbrew install-cpanm
    rakudobrew build moar
    rakudobrew build zef

Then put this repo somewhere and install its deps:

    mkdir ~/.Rele6sr
    cd ~/.Rele6sr
    git clone https://github.com/zoffixznet/Rele6sr .
    ./install-deps
