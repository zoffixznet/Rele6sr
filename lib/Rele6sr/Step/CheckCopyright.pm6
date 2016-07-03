use Rele6sr::StepBase::Instructions;
unit class Rele6sr::Step::CheckCopyright
    is Rele6sr::StepBase::Instructions;

has $.menu = 'Check copyright';
has $.instructions = q:to/END/;
    If it’s a month relatively early in the calendar year, double-check that
    the copyright date in the README file includes the current year. (It’s not
    necessary to update copyright dates in other files, unless you know that a
    given file has been modified in a year not reflected by the file’s copyright
    notice.)
    END
