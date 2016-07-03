use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::UpdateWikipedia
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Update Wikipedia';
has $.instructions = q:to/END/;
    Update the Wikipedia entry at
    [http://en.wikipedia.org/wiki/Rakudo](http://en.wikipedia.org/wiki/Rakudo).
    END
