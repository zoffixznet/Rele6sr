use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::InlinePerl5
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Install Inline::Perl5';
has $.instructions = q:to/END/;
    Install Inline::Perl5 so stresstest can use it:

        git clone https://github.com/tadzik/panda
        export PATH=`pwd`/install/bin:$PATH
        cd panda; perl6 bootstrap.pl
        cd ..
        export PATH=`pwd`/install/share/perl6/site/bin:$PATH
        panda install Inline::Perl5
    END
