use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::ReleaseTarball
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Create release tarball';
has $.instructions = q:to/END/;
    Create a tarball by entering `make release VERSION=YYYY.MM`, where
    `YYYY.MM` is the month for which the release is being made. This will
    create a tarball file named `rakudo-YYYY.MM.tar.gz`

    **Caution:** this step removes any untracked files in `t/spec`. So
    please make a backup if you have any important data in there.

    Because we tested the stable language spec last, above, those are the
    tests that will end up in the release tarball.
    END
