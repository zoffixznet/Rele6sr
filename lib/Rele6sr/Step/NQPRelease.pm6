use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::NQPRelease
    is Rele6sr::StepBase::Instructions;

has $.menu = 'NQP release';
has $.instructions = q:to/END/;
    Create an NQP release with the same YYYY.MM version number as Rakudo.
    Follow NQP’s docs/release_guide.pod file to do that.
    END
