use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::AnnounceRelease
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Announce the release';
has $.instructions = q:to/END/;
    To avoid public confusion with Rakudo Star releases, we now publish
    compiler release announcements ONLY to
    [perl6-compiler@perl.org](mailto:perl6-compiler@perl.org).

    Don’t send out any announcements until the files are actually available
    per step 14 above.
    END
