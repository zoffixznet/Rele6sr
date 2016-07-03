use Rele6sr::StepBase::Base;
use Text::MultiMarkdown:from<Perl5> <markdown>;
unit class Rele6sr::StepBase::Instructions is Rele6sr::StepBase::Base;

has Str:D $.menu_type = 'Instructions';
has Str:D $.instructions = 'N/A';

method content {
    markdown $.instructions;
}
