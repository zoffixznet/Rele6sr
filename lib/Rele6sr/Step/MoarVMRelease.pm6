use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::MoarVMRelease
    is Rele6sr::StepBase::Instructions;

has $.menu = 'MoarVM release';
has $.instructions = q:to/END/;
    Ensure that a monthly MoarVM release has been completed. Those releases
    are typically handled by a separate team.
    END
