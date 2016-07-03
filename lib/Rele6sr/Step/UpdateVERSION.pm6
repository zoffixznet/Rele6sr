use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::UpdateVERSION
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Update VERSION';
has $.instructions = q:to/END/;
    Go back to the Rakudo repository, and update the NQP dependency:

        echo YYYY.MM > tools/build/NQP_REVISION
        git commit -m '[release] bump NQP revision' tools/build/NQP_REVISION
    END
