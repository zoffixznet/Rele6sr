use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::ReviewGitLog
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Review git log';
has $.instructions = q:to/END/;
    Review the git log history to see if any additional items need to be added to the ChangeLog. This can be conveniently done with

        git log --since=yyyy-mm-dd --reverse # find commits
        # update ChangeLog
        git commit docs/ChangeLog # commit changes
    END
