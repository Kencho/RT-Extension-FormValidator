package t::RuleValidators::Field;

use strict;
use warnings;

use Test::More;
use Devel::Cover;
use Try::Tiny;

require_ok('FormValidator::AbstractRuleValidator');
require_ok('FormValidator::RuleValidators::Field');

sub test_construction {
    try {
        FormValidator::RuleValidators::Field->new();
        fail('An exception was expected when trying to construct without either field_name or field_name_regex');
    }
    catch {
        pass('Exception received when trying to construct without either field_name or field_name_regex');
    };

    try {
        FormValidator::RuleValidators::Field->new(field_name_regex => '.*my-field');
        FormValidator::RuleValidators::Field->new(field_name => 'my-field');
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_rule_validator = FormValidator::RuleValidators::Field->new(field_name_regex => '.*my-field');

    isa_ok($field_rule_validator, 'FormValidator::AbstractRuleValidator');
    isa_ok($field_rule_validator, 'FormValidator::RuleValidators::Field');

    return;
}

sub test_reflective_construction {
    try {
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::Field');
        fail('An exception was expected when trying to construct without either field_name or field_name_regex');
    }
    catch {
        pass('Exception received when trying to construct without either field_name or field_name_regex');
    };

    try {
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::Field', field_name_regex => '.*my-field');
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::Field', field_name => 'my-field');
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_rule_validator = FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::Field', field_name_regex => '.*my-field');

    isa_ok($field_rule_validator, 'FormValidator::AbstractRuleValidator');
    isa_ok($field_rule_validator, 'FormValidator::RuleValidators::Field');

    return;
}

sub test_field_name_regex_selection {
    my $field_regex_name_rule_validator;
    my $regex;

    $regex = q{simple};
    $field_regex_name_rule_validator = FormValidator::RuleValidators::Field->new(field_name_regex => $regex);
    ok($field_regex_name_rule_validator->Applies(field_name => "simple"), "Matches regex");
    ok($field_regex_name_rule_validator->Applies(field_name => "A bit less simple name"), "Matches regex");
    ok(!$field_regex_name_rule_validator->Applies(field_name => "complex"), "Doesn't match regex");
    $regex = q{.*my-field\s+name with spaces};
    $field_regex_name_rule_validator = FormValidator::RuleValidators::Field->new(field_name_regex => $regex);
    ok($field_regex_name_rule_validator->Applies(field_name => "my-block-my-field\tname with spaces"), "Matches regex");
    $regex = q{^Strictly$};
    $field_regex_name_rule_validator = FormValidator::RuleValidators::Field->new(field_name_regex => $regex);
    ok($field_regex_name_rule_validator->Applies(field_name => "Strictly"), "Matches regex");
    ok(!$field_regex_name_rule_validator->Applies(field_name => " Strictly "), "Doesn't match regex");

    return;
}

sub test_field_name_selection {
    my $field_name_rule_validator;
    my $name;

    $name = q{simple};
    $field_name_rule_validator = FormValidator::RuleValidators::Field->new(field_name => $name);
    ok($field_name_rule_validator->Applies(field_name => "simple"), "Matches name");
    ok(!$field_name_rule_validator->Applies(field_name => "Simple"), "Doesn't match casing");
    $name = q{A name with Spaces, punctuation, and Öthers};
    $field_name_rule_validator = FormValidator::RuleValidators::Field->new(field_name => $name);
    ok($field_name_rule_validator->Applies(field_name => "A name with Spaces, punctuation, and Öthers"), "Matches name");

    return;
}

subtest 'Construction' => sub {
    test_construction();
    test_reflective_construction();

    done_testing();
};

subtest 'Selection' => sub {
    test_field_name_regex_selection();
    test_field_name_selection();

    done_testing();
};

done_testing();

1;