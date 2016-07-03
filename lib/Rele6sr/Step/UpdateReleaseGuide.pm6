use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::UpdateReleaseGuide
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Update release guide';
has $.instructions = q:to/END/;
    Update the release dates and names at the bottom of the release guide
    (docs/release_guide.pod). Also improve these instructions if you find any
    steps that are missing.

        git commit docs/release_guide.pod
    END
