use Rele6sr::StepBase::Base;
unit class Rele6sr::StepBase::RT is Rele6sr::StepBase::Base;
use RT::Client::REST:from<Perl5>;

state $rt;

has Str:D $.menu_type = 'RT';
has Str:D $.instructions = 'N/A';

has $.rt = do {
    without $rt {
        say "Config: " ~ self.config<rt><user>;
        $rt = RT::Client::REST.new: :server<https://rt.perl.org/>;
        $rt.login: username => self.config<rt><user>,
                   password => self.config<rt><pass>;
    }
    $rt;
};

method content {
    # markdown $.instructions;
    join ' ', $.rt.search:
        type  => 'ticket',
        query => "Status = 'stalled'";
}
