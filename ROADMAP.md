## Released By Robot

### Work to do between releases

The bot knows when the next release is supposed to happen. A week before it,
it'll produce a reminder (perhaps a couple of times over several days):

```
    <Rele6sr> 🎺🎺🎺 Friends! I bear good news! Rakudo's release will happen in
    just 6 days! Please update the ChangeLog with anything you worked on that
    should be known to our users. 🎺🎺🎺
    <Rele6sr> 🎺🎺🎺 Here are still-open new RT tickets since last release:
    http://bug.perl6.party/1471361447.html And here is the git log output for
    commits since last release: http://bug.perl6.party/1471361450.html 🎺🎺🎺
```

The second line includes a list of new RT tickets since last release (does
not include tickets that have been resolved) and a `git log` of commits since
last release. This info can also be explicitly requested with command `status`

The tickets are there for review for any release-blocking issues. The commits
are there to populate the changelog.

The app will let trusted parties log in and:

* Mark tickets as non-release-blocking
* Mark commits as added to changelog

As the release date approaches, the release manager will perform those tasks,
so that on the release date we have proper record that everything was reviewed
and logged. Since the state is saved, these can be done throughout the month,
which is less tasking on the release manager.

### Release Date

On release date the release manager simply issues the command `release` to the
bot and the bot will:

* Prepare the release announcement (so far the plan is for the bot to show a draft to the release manager first, and take any modifications if needed).
* Fire up Google Compute Engine instances in several operating systems, such
    as Debian, Red Hat, and Windows Server 2012. Debian will be used to make releases from and others are just for testing.
* Build, test, and tag NQP
* Build, stresstest, and tag Rakudo
* Generate and sign the NQP and Rakudo tarballs and upload them to rakudo.org
* Email the release announcement to `perl6-compiler@perl.org`
* Announce on #perl6-dev that it's done and provide logs of everything

### Egress

The release process will be aborted if any tests fail or hang. The bot will
also support dry runs that won't produce any commits, uploads, or emails.
It may be possible to perform various stages of the release process separately
(for example, requesting the bot to smoke test Rakudo on multiple OSes, without
making any releases).

### ??? Profit!

Excluding any major issues, this new process simplifies the job of the release
manager to spending just a couple of minutes every few days to review RT
tickets and add changelog entries and then issue a single bot command on the
release day.

Since the web app will keep track of which tickets have been reviewed and
which commits have been added to the changelog, it's much harder for things
to slip through the cracks.


