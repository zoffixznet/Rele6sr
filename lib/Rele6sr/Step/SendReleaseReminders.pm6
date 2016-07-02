use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::SendReleaseReminders
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Send release reminders';
has $.instructions = q:to/END/;
    Remind people of the upcoming release, invite people to update the
    ChangeLog file, update the ROADMAP, etc.
    END
