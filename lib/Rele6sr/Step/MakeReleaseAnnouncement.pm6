use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::MakeReleaseAnnouncement
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Make release announcement';
has $.instructions = q:to/END/;
    Create a release announcement in `docs/announce/YYYY.MM.md` in markdown
    format. You can often use the previous release’s file as a starting point,
    updating the release number, version information, name, etc. as appropriate.

        git add docs/announce/YYYY.MM.md
        git commit docs

    There is a helper script `tools/create-release-announcement.pl` that will
    create a basic release announcement for you based on the state of the
    repository and the current date. Feel free to use it to save yourself some
    time, but please look over its output if you decide to use it.

    Highlight areas in which the new release is significant.

    Include a list of contributors since the last release in the announcement. You can get an automatically generated list by running

        perl6 tools/contributors.pl6

    Please check the result manually for duplicates and other errors. Note that you may not be able to run your system perl6 in a local checkout, you may have to wait until you build in this directory and use `./perl6`

        git add docs/announce/YYYY.MM.md
        git commit docs
    END
