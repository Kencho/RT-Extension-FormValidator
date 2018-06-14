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

    return;
}

sub test_checking {
    my $always_condition = FormValidator::Conditions::Always->new();

    is($always_condition->Check(), 1, "Condition checking is always expected to pass");

    return;
}

sub test_parameterless_check {
    my $always_condition = FormValidator::Conditions::Always->new();

    try {
        $always_condition->Check();
        pass('It\'s okay to an always-pass test without arguments')
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
