unit class Rele6sr::DB;
use DBIish;

has $.dbh;

method connect {
    $!dbh = DBIish.connect: 'SQLite', :database<release.db>;

    $!dbh.do: q:to/END/;
        CREATE TABLE IF NOT EXISTS completed (
            name         TEXT,
            is_completed BOOL
        )
        END

    self;
}

method is_completed (Str $name) {
    return .<is_completed> // False
        given self!dbh-select-one:
            'SELECT * FROM completed WHERE name = ?', $name;
}

method mark-completed (Str $name) {
    $!dbh.do: 'DELETE FROM completed WHERE name = ?', $name;
    $!dbh.do:
        'INSERT INTO completed (name, is_completed) VALUES (?, ?)',
        $name, True;
}

method unmark-completed (Str $name) {
    $!dbh.do: 'DELETE FROM completed WHERE name = ?', $name;
    $!dbh.do:
        'INSERT INTO completed (name, is_completed) VALUES (?, ?)',
        $name, False;
}

method !dbh-select-one (|c) {
    self!dbh-select(|c)[0] // %();
}

method !dbh-select (Str $sql, *@args) {
    given $!dbh.prepare: $sql {
        .execute: |@args;
        .allrows: :array-of-hash;
    }
}
