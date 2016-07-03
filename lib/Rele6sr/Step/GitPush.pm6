use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::GitPush
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Git push';
has $.instructions = q:to/END/;
    Make sure any locally modified files have been pushed back to GitHub.

        git status
        git push
    END
