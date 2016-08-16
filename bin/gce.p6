use lib <lib>;

use Rele6sr::IRC::Config;
use GoogleComputeEngine::Instance;

my $gce = GoogleComputeEngine::Instance.new:
    :project<Perl6-Build>
    :zone<us-east1-b>
    :name<perlbuild2>;

$gce.start;
