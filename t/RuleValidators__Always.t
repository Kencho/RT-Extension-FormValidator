package t::RuleValidators::Always;

use strict;
use warnings;

use Test::More;
use Devel::Cover;
use Try::Tiny;

require_ok('FormValidator::AbstractRuleValidator');
require_ok('FormValidator::RuleValidators::Always');

sub test_construction {
    try {
        FormValidator::RuleValidators::Always->new();
    }
    catch {
        fail('No exception was expected when trying to construct without arguments');
    };

    try {
        FormValidator::RuleValidators::Always->new(queue_id => 123);
    }
    catch {
        fail('No exception was expected when trying to construct with arguments');
    };

    my $always_rule_validator = FormValidator::RuleValidators::Always->new();

    isa_ok($always_rule_validator, 'FormValidator::AbstractRuleValidator');
    isa_ok($always_rule_validator, 'FormValidator::RuleValidators::Always');

    return;
}

sub test_reflective_construction {
    try {
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::Always');
    }
    catch {
        fail('No exception was expected when trying to construct without arguments');
    };

    try {
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::Always', queue_id => 123);
    }
    catch {
        fail('No exception was expected when trying to construct with arguments');
    };

    my $always_rule_validator = FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::Always');

    isa_ok($always_rule_validator, 'FormValidator::AbstractRuleValidator');
    isa_ok($always_rule_validator, 'FormValidator::RuleValidators::Always');

    return;
}

sub test_checking {
    my $always_rule_validator = FormValidator::RuleValidators::Always->new();

    is($always_rule_validator->Applies(), 1, "Rule application is always expected to pass");

    return;
}

sub test_parameterless_check {
    my $always_rule_validator = FormValidator::RuleValidators::Always->new();

    try {
        $always_rule_validator->Applies();
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
