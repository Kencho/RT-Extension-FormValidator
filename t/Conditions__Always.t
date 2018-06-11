package t::Conditions::Always;

use strict;
use warnings;

use Test::More;
use Devel::Cover;
use Try::Tiny;

require_ok('FormValidator::AbstractCondition');
require_ok('FormValidator::Conditions::Always');

sub test_construction {
    try {
        FormValidator::Conditions::Always->new();
    }
    catch {
        fail('No exception was expected when trying to construct without arguments');
    };

    try {
        FormValidator::Conditions::Always->new(queue_id => 123);
    }
    catch {
        fail('No exception was expected when trying to construct with arguments');
    };

    my $always_condition = FormValidator::Conditions::Always->new();

    isa_ok($always_condition, 'FormValidator::AbstractCondition');
    isa_ok($always_condition, 'FormValidator::Conditions::Always');
    is($always_condition->Inverted(), 0, 'Not inverted by default');

    return;
}

sub test_reflective_construction {
    try {
        FormValidator::AbstractCondition::Build('FormValidator::Conditions::Always');
    }
    catch {
        fail('No exception was expected when trying to construct without arguments');
    };

    try {
        FormValidator::AbstractCondition::Build('FormValidator::Conditions::Always', queue_id => 123);
    }
    catch {
        fail('No exception was expected when trying to construct with arguments');
    };

    my $always_condition = FormValidator::AbstractCondition::Build('FormValidator::Conditions::Always');

    isa_ok($always_condition, 'FormValidator::AbstractCondition');
    isa_ok($always_condition, 'FormValidator::Conditions::Always');
    is($always_condition->Inverted(), 0, 'Not inverted by default');

    return;
}

sub test_checking {
    my $always_condition = FormValidator::Conditions::Always->new();
    my $inverted_always_condition = FormValidator::Conditions::Always->new(inverted => 1);

    is($always_condition->Check(), 1, "Condition checking is always expected to pass");
    is($inverted_always_condition->Check(), 0, "Inverted condition checking is never expected to pass");

    return;
}

sub test_parameterless_check {
    my $always_condition = FormValidator::Conditions::Always->new();

    try {
        $always_condition->Check();
    }
    catch {
        fail('No exception was expected when checking without an argument');
    };

    return;
}

subtest 'Construction' => sub {
    test_construction();
    test_reflective_construction();

    done_testing();
};

subtest 'Checking' => sub {
    test_checking();
    test_parameterless_check();

    done_testing();
};

done_testing();

1;
