use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::UpdateLeapSeconds
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Update leap seconds';
has $.instructions = q:to/END/;
    Update Rakudo’s leap-second tables:

        perl tools/update-tai-utc.pl

    If a new leap second has been announced, tai-utc.pm will be modified, so
    commit the new version:

        git commit src

    But probably there won’t be any new leap seconds, in which case the file
    will be unchanged.
    END
