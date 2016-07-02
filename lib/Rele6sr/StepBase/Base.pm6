unit class Rele6sr::StepBase::Base;
has Str:D $.menu      = 'N/A';
has Str:D $.menu_type = 'N/A';
has $.db;

method url {
    "$.menu_type/$.menu".subst: /\W/, '-', :g;
}

method name { self.url }

method is_completed { $!db.is_completed: self.name }

method complete {
    $!db.mark-completed: self.name;
}

method uncomplete {
    $!db.unmark-completed: self.name;
}
