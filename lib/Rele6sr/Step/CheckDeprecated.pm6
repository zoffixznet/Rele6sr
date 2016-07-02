use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::CheckDeprecated
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Check deprecated features';
has $.instructions = q:to/END/;
    Check if any DEPRECATED code needs to be removed because the end of the
    deprecation cycle is reached. One way of doing this, is to grep on the
    YYYYMM of the release (e.g. 201412 for the 2014.12 release). If you find any
    occurrences, remove the code and make sure the spectest is still ok.
    END
