unit class Rele6sr;

use Rele6sr::DB;
use Rele6sr::RT;
use Rele6sr::Step;
use Rele6sr::Shell;

has %.steps;
has $.db;

submethod BUILD (:$config) {
    $!db = Rele6sr::DB.new.connect;
    for $config<steps>.kv -> $idx, $step {
        %!steps{.url} = %(
            step => $_,
            sort => $idx,
        ) given ::("Rele6sr::Step::$step").new: :$!db, :$config;
    }
}

method steps_ordered {
    %!steps.values.sort(*<sort>).map: *<step>;
}
