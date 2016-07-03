use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::TestTarball
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Test the tarball';
has $.instructions = q:to/END/;
    Unpack the tar file into another area, and test that it builds and runs
    properly using the same process in steps 11-13. For step 13, just run "make
    stresstest"; you're only testing the official spec tests here, and cannot
    switch between branches. If there are any problems, fix them and go back to
    step 11.
    END
