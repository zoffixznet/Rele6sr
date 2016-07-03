use Rele6sr::StepBase::RT;
unit class Rele6sr::Step::ReviewRTQueue is Rele6sr::StepBase::RT;

has $.menu = 'Review RT Queue';
has $.instructions = q:to/END/;
    Review the RT queue for tickets that might need resolving prior to the
    release, addressing them as needed. “Tickets that need resolving” is left to
    your discretion. Any problem that has a large impact on users is worth
    addressing either as a fix or as prominent documentation (the README and/or
    the release announcement).
    END
