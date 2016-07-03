use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::Celebrate
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Celebrate';
has $.instructions = q:to/END/;
    You’re done! Celebrate with the appropriate amount of fun.
    END
