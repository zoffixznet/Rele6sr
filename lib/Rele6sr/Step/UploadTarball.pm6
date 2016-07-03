use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::UploadTarball
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Upload the tarball';
has $.instructions = q:to/END/;
    Upload the tarball and the signature to
    [http://rakudo.org/downloads/rakudo](http://rakudo.org/downloads/rakudo):

        scp rakudo-YYYY.MM.tar.gz rakudo-YYY-MM.tar.gz.asc \
           rakudo@rakudo.org:public_html/downloads/rakudo/

    If you do not have permissions for that, ask one of (pmichaud, jnthn,
    FROGGS, masak, tadzik, moritz, PerlJam/perlpilot, [Coke], lizmat, timotimo,
    fsergot, hoelzro) on #perl6 to do it for you.
    END
