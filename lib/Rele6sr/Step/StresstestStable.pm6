use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::StresstestStable
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Run stresstest (stable)';
has $.instructions = q:to/END/;
    Now run the stresstests for stable and lastest specs.

        (cd t/spec && git checkout 6.c-errata) # test stable language spec
        make stresstest

    There are many tests to run for the stresstest target. If you have a machine with multiple CPU cores, you may want to execute that last as

        TEST_JOBS=4 make stresstest

    where 4 is the number of CPU cores. This should make the total time to execute all of the tests dramatically less.

    Note that any failures against the stable language spec must be fixed before a release can be made. Also, you will see warnings about missing test files; this is because we only have one list of files, and new tests may have been added after the last version of the spec was frozen.

    Continue adjusting things until make stresstest passes as expected. Often this means fixing a bug, fudging a test, or (temporarily?) commenting out a test file in t/spectest.data . Use your best judgment or ask others if uncertain what to do here.
    END
