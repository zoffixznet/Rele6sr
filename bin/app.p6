use lib <lib>;

use Rele6sr;
use Mojolicious::Lite:from<Perl5>;
use Mojolicious::Plugin::AssetPack:from<Perl5>;

plugin Config    => %( :file<rele6sr.conf>             );
plugin AssetPack => %( :pipes<Sass JavaScript Combine> );

app.asset.process: 'app.css' => <sass/main.scss>;
app.asset.process: 'app.js'  => <js/main.js>;

helper r6 => &helper-r6;

get '/', *.stash: :template<index>;
under '/step/:name' => {
    $^c.stash:
        template  => 'step',
        step      => $^c.r6.steps{ $^c.param('name') }<step>;
}
get '/view';
get '/complete',   *.stash('step').complete;
get '/uncomplete', *.stash('step').uncomplete;

app.start;

sub helper-r6 {
    state $r6 = Rele6sr.new: :steps(|$^c.config<steps>);
}
