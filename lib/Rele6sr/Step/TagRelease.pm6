use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::TagRelease
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Tag the release';
has $.instructions = q:to/END/;
    Tag the release by its release month ("YYYY.MM") and its code name.

        git tag -u <email> -s -a -m"tag release #nn" YYYY.MM    # e.g., 2013.08
        git push --tags

    The -s tells git to sign the release with your PGP/GPG key, so it will
    likely ask you for the passphrase of your secret key.

    If you have no PGP key, you might need to
    [create one first](https://fedoraproject.org/wiki/Creating_GPG_Keys).
    Should that prove impossible, you can omit the -s from the command line.
    END
