use lib <lib>;

use Rele6sr;
use Mojolicious::Lite:from<Perl5>;
use Mojolicious::Plugin::AssetPack:from<Perl5>;

plugin Config    => %( :file<rele6sr.conf>             );
plugin AssetPack => %( :pipes<Sass JavaScript Combine> );

app.asset.process: 'app.css' => <sass/main.scss>;
app.asset.process: 'app.js'  => <js/main.js>;

helper bt        => &helper-bt;
helper is_marked => &helper-is-marked;
helper r6        => &helper-r6;

get '/', {
    $^c.stash: :template<index>, :step($^c.r6.steps_ordered[0]);
}, 'index';

get '/mark/:what' => {
    $^c.r6.db.mark-completed: $^c.param: 'what';
    $^c.render: json => { status => 'OK' };
}
get '/unmark/:what' => {
    $^c.r6.db.unmark-completed: $^c.param: 'what';
    $^c.render: json => { status => 'OK' };
}
get '/ismark/:what' => {
    $^c.render: json => %(
        status       => 'OK',
        is_completed => $^c.is_marked: $^c.param: 'what'
    );
}
get '/toggle-mark/:what' => {
    my $meth = $^c.is_marked($^c.param: 'what')
        ?? 'unmark-completed' !! 'mark-completed';

    $^c.r6.db."$meth"($^c.param: 'what');
    $^c.render: json => { status => 'OK' };
}

under '/step/:name' => {
    $^c.stash:
        template  => 'step',
        step      => $^c.r6.steps{ $^c.param: 'name' }<step>;
}
get '/view';
get '/complete',   *.stash('step').complete;
get '/uncomplete', *.stash('step').uncomplete;

app.start;

sub helper-r6 {
    state $r6 = Rele6sr.new: :config($^c.config);
}

sub helper-bt ($, $cond, $button) {
    say "###### $cond: $button########";
    $cond ?? $button !! 'default';
}

sub helper-is-marked ($c, $what) {
    $c.r6.db.is_completed: $what;
}
