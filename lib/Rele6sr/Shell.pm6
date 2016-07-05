unit class Rele6sr::Shell;

has $!shell;

submethod BUILD {
    $!shell = Proc::Async.new: '/bin/sh', :w;
    $!shell.stdout.tap(-> $v { say "Output: $v" });
    $!shell.stderr.tap(-> $v { say "Error:  $v" });
    $!shell.start;
}

method temp {
    self.command: 'cd $(mktemp -d); pwd';
}

method command (Str:D $cmd) {
    await $!shell.write: "$cmd\n".encode;
}
