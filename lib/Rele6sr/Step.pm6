#### We keep all these steps in one file, because spreading them across
#### individual files shoots the loading time of the app to like 40+ seconds
unit package Rele6sr::Step;

class Base {
    has Str:D $.menu      = 'N/A';
    has Str:D $.menu_type = 'N/A';
    has $.db;
    has $.config;

    method url {
        "$.menu_type/$.menu".subst: /\W/, '-', :g;
    }

    method name { self.url }

    method is_completed { $!db.is_completed: self.name }

    method complete {
        $!db.mark-completed: self.name;
    }

    method uncomplete {
        $!db.unmark-completed: self.name;
    }
}

class Base::Instructions is Base {
    use Text::MultiMarkdown:from<Perl5> <markdown>;

    has Str:D $.menu_type = 'Instructions';
    has Str:D $.instructions = 'N/A';

    method content {
        [ content => markdown $.instructions ];
    }
}

class Base::RT is Base {
    use Rele6sr::RT;

    state $rt;

    has Str:D $.menu_type = 'RT';
    has Str:D $.instructions = 'N/A';

    has $.rt = Rele6sr::RT.new: :user(self.config<rt><user>),
                                :pass(self.config<rt><pass>);

    method content {
        [
            'template', 'ReviewRTQueue',
            'args', %( :tickets($.rt.search) ),
        ]
    }
}


class AnnounceRelease is Base::Instructions {
    has $.menu = 'Announce the release';
    has $.instructions = q:to/END/;
        To avoid public confusion with Rakudo Star releases, we now publish
        compiler release announcements ONLY to
        [perl6-compiler@perl.org](mailto:perl6-compiler@perl.org).

        Don’t send out any announcements until the files are actually
        available per step 14 above.
        END
}


class Celebrate is Base::Instructions {
    has $.menu = 'Celebrate';
    has $.instructions = q:to/END/;
        You’re done! Celebrate with the appropriate amount of fun.
        END
}


class CheckCopyright is Base::Instructions {
    has $.menu = 'Check copyright';
    has $.instructions = q:to/END/;
        If it’s a month relatively early in the calendar year, double-check
        that the copyright date in the README file includes the current year.
        (It’s not necessary to update copyright dates in other files, unless
        you know that a given file has been modified in a year not reflected
        by the file’s copyright notice.)
        END
}


class CheckDeprecated is Base::Instructions {
    has $.menu = 'Check deprecated features';
    has $.instructions = q:to/END/;
        Check if any DEPRECATED code needs to be removed because the end of
        the deprecation cycle is reached. One way of doing this, is to grep
        on the YYYYMM of the release (e.g. 201412 for the 2014.12 release).
        If you find any occurrences, remove the code and make sure the
        spectest is still ok.
        END
}


class CompileAndRunFromClean is Base::Instructions {
    has $.menu = 'Compile and run from clean';
    has $.instructions = q:to/END/;
        Make sure everything compiles and runs from a known clean state:

            make realclean
            perl Configure.pl --gen-moar --backends=ALL
            make
            make install
            make test
        END
}


class Rele6sr::Step::GitPush is Base::Instructions {
    has $.menu = 'Git push';
    has $.instructions = q:to/END/;
        Make sure any locally modified files have been pushed back to GitHub.

            git status
            git push
        END
}


class InlinePerl5 is Base::Instructions {
    has $.menu = 'Install Inline::Perl5';
    has $.instructions = q:to/END/;
        Install Inline::Perl5 so stresstest can use it:

            git clone https://github.com/tadzik/panda
            export PATH=`pwd`/install/bin:$PATH
            cd panda; perl6 bootstrap.pl
            cd ..
            export PATH=`pwd`/install/share/perl6/site/bin:$PATH
            panda install Inline::Perl5
        END
}


class MakeReleaseAnnouncement is Base::Instructions {
    has $.menu = 'Make release announcement';
    has $.instructions = q:to/END/;
        Create a release announcement in `docs/announce/YYYY.MM.md` in
        markdown format. You can often use the previous release’s file as a
        starting point, updating the release number, version information,
        name, etc. as appropriate.

            git add docs/announce/YYYY.MM.md
            git commit docs

        There is a helper script `tools/create-release-announcement.pl` that
        will create a basic release announcement for you based on the state
        of the repository and the current date. Feel free to use it to save
        yourself some time, but please look over its output if you decide to
        use it.

        Highlight areas in which the new release is significant.

        Include a list of contributors since the last release in the
        announcement. You can get an automatically generated list by running

            perl6 tools/contributors.pl6

        Please check the result manually for duplicates and other errors.
        Note that you may not be able to run your system perl6 in a local
        checkout, you may have to wait until you build in this directory and
        use `./perl6`

            git add docs/announce/YYYY.MM.md
            git commit docs
        END
}


class MoarVMRelease is Base::Instructions {
    has $.menu = 'MoarVM release';
    has $.instructions = q:to/END/;
        Ensure that a monthly MoarVM release has been completed. Those
        releases are typically handled by a separate team.
        END
}


class NQPRelease is Base::Instructions {
    has $.menu = 'NQP release';
    has $.instructions = q:to/END/;
        Create an NQP release with the same YYYY.MM version number as Rakudo.
        Follow NQP’s docs/release_guide.pod file to do that.
        END
}


class ReleaseTarball is Base::Instructions {
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
}


class ReviewGitLog is Base::Instructions {
    has $.menu = 'Review git log';
    has $.instructions = q:to/END/;
        Review the git log history to see if any additional items need to be
        added to the ChangeLog. This can be conveniently done with

            git log --since=yyyy-mm-dd --reverse # find commits
            # update ChangeLog
            git commit docs/ChangeLog # commit changes
        END
}


class ReviewRTQueue is Base::RT {
    has $.menu = 'Review RT Queue';
    has $.instructions = q:to/END/;
        Review the RT queue for tickets that might need resolving prior to
        the release, addressing them as needed. “Tickets that need resolving”
        is left to your discretion. Any problem that has a large impact on
        users is worth addressing either as a fix or as prominent
        documentation (the README and/or the release announcement).
        END
}


class SendReleaseReminders is Base::Instructions {
    has $.menu = 'Send release reminders';
    has $.instructions = q:to/END/;
        Remind people of the upcoming release, invite people to update the
        ChangeLog file, update the ROADMAP, etc.
        END
}


class SignTarball is Base::Instructions {
    has $.menu = 'Sign the tarball';
    has $.instructions = q:to/END/;
        Sign the tarball with your PGP key:

            gpg -b --armor rakudo-YYYY-MM.tar.gz
        END
}


class StresstestMaster is Base::Instructions {
    has $.menu = 'Run stresstest (master)';
    has $.instructions = q:to/END/;
        Now run the stresstests for stable and lastest specs.

            (cd t/spec && git checkout master) # test latest language spec
            make stresstest

        There are many tests to run for the stresstest target. If you have a
        machine with multiple CPU cores, you may want to execute that last as

            TEST_JOBS=4 make stresstest

        where 4 is the number of CPU cores. This should make the total time
        to execute all of the tests dramatically less.

        Note that any failures against the stable language spec must be fixed
        before a release can be made. Also, you will see warnings about
        missing test files; this is because we only have one list of files,
        and new tests may have been added after the last version of the spec
        was frozen.

        Continue adjusting things until make stresstest passes as expected.
        Often this means fixing a bug, fudging a test, or (temporarily?)
        commenting out a test file in t/spectest.data . Use your best
        judgment or ask others if uncertain what to do here.
        END
}


class StresstestStable is Base::Instructions {
    has $.menu = 'Run stresstest (stable)';
    has $.instructions = q:to/END/;
        Now run the stresstests for stable and lastest specs.

            (cd t/spec && git checkout 6.c-errata) #test stable language spec
            make stresstest

        There are many tests to run for the stresstest target. If you have a
        machine with multiple CPU cores, you may want to execute that last as

            TEST_JOBS=4 make stresstest

        where 4 is the number of CPU cores. This should make the total time
        to execute all of the tests dramatically less.

        Note that any failures against the stable language spec must be
        fixed before a release can be made. Also, you will see warnings
        about missing test files; this is because we only have one list of
        files, and new tests may have been added after the last version of
        the spec was frozen.

        Continue adjusting things until make stresstest passes as expected.
        Often this means fixing a bug, fudging a test, or (temporarily?)
        commenting out a test file in t/spectest.data . Use your best
        judgment or ask others if uncertain what to do here.
        END
}


class TagRelease is Base::Instructions {
    has $.menu = 'Tag the release';
    has $.instructions = q:to/END/;
        Tag the release by its release month ("YYYY.MM") and its code name.

            git tag -u <email> -s -a -m"tag release #nn" YYYY.MM  # e.g., 2013.08
            git push --tags

        The -s tells git to sign the release with your PGP/GPG key, so it
        will likely ask you for the passphrase of your secret key.

        If you have no PGP key, you might need to
        [create one first](https://fedoraproject.org/wiki/Creating_GPG_Keys).
        Should that prove impossible, you can omit the -s from the command
        line.
        END
}


class TestTarball is Base::Instructions {
    has $.menu = 'Test the tarball';
    has $.instructions = q:to/END/;
        Unpack the tar file into another area, and test that it builds and
        runs properly using the same process in steps 11-13. For step 13,
        just run "make stresstest"; you're only testing the official spec
        tests here, and cannot switch between branches. If there are any
        problems, fix them and go back to step 11.
        END
}


class UpdateLeapSeconds is Base::Instructions {
    has $.menu = 'Update leap seconds';
    has $.instructions = q:to/END/;
        Update Rakudo’s leap-second tables:

            perl tools/update-tai-utc.pl

        If a new leap second has been announced, tai-utc.pm will be modified,
        so commit the new version:

            git commit src

        But probably there won’t be any new leap seconds, in which case the
        file will be unchanged.
        END
}


class UpdateNQPDependency is Base::Instructions {
    has $.menu = 'Update NQP dependency';
    has $.instructions = q:to/END/;
        Go back to the Rakudo repository, and update the NQP dependency:

            echo YYYY.MM > tools/build/NQP_REVISION
            git commit -m '[release] bump NQP revision' tools/build/NQP_REVISION
        END
}


class UpdateReleaseGuide is Base::Instructions {
    has $.menu = 'Update release guide';
    has $.instructions = q:to/END/;
        Update the release dates and names at the bottom of the release guide
        (docs/release_guide.pod). Also improve these instructions if you find
        any steps that are missing.

            git commit docs/release_guide.pod
        END
}


class UpdateVERSION is Base::Instructions {
    has $.menu = 'Update VERSION';
    has $.instructions = q:to/END/;
        Go back to the Rakudo repository, and update the NQP dependency:

            echo YYYY.MM > tools/build/NQP_REVISION
            git commit -m '[release] bump NQP revision' tools/build/NQP_REVISION
        END
}


class UpdateWikipedia is Base::Instructions {
    has $.menu = 'Update Wikipedia';
    has $.instructions = q:to/END/;
        Update the Wikipedia entry at
        [http://en.wikipedia.org/wiki/Rakudo](http://en.wikipedia.org/wiki/Rakudo).
        END
}


class UploadTarball is Base::Instructions {
    has $.menu = 'Upload the tarball';
    has $.instructions = q:to/END/;
        Upload the tarball and the signature to
        [http://rakudo.org/downloads/rakudo
        ](http://rakudo.org/downloads/rakudo):

            scp rakudo-YYYY.MM.tar.gz rakudo-YYY-MM.tar.gz.asc \
               rakudo@rakudo.org:public_html/downloads/rakudo/

        If you do not have permissions for that, ask one of (pmichaud, jnthn,
        FROGGS, masak, tadzik, moritz, PerlJam/perlpilot, [Coke], lizmat,
        timotimo, fsergot, hoelzro) on #perl6 to do it for you.
        END
}
