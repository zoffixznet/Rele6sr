use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::CompileAndRunFromClean
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Compile and run from clean';
has $.instructions = q:to/END/;
    Make sure everything compiles and runs from a known clean state:

        make realclean
        perl Configure.pl --gen-moar --backends=ALL
        make
        make install
        make test
    END
