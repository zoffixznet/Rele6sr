use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::SignTarball
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Sign the tarball';
has $.instructions = q:to/END/;
    Sign the tarball with your PGP key:

        gpg -b --armor rakudo-YYYY-MM.tar.gz
    END
