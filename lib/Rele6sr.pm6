unit class Rele6sr;

use Rele6sr::DB;
use Rele6sr::Step::SendReleaseReminders;

has %.steps;
has $.db;

submethod BUILD (:@steps) {
    for @steps.kv -> $idx, $step {
        my $step-module = "Rele6sr::Step::$step";
        require ::($step-module);

        $!db = Rele6sr::DB.new.connect;

        %!steps{.url} = %(
            step => $_,
            sort => $idx,
        ) given ::($step-module).new: :$!db;
    }
}

method steps_ordered {
    %!steps.values.sort(*<sort>).map: *<step>;
}
