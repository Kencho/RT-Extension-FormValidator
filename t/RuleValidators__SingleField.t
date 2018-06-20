package t::RuleValidators::SingleField;

use strict;
use warnings;

use Test::More;
use Devel::Cover;
use Try::Tiny;

require_ok('FormValidator::AbstractRuleValidator');
require_ok('FormValidator::RuleValidators::SingleField');

sub test_construction {
    try {
        FormValidator::RuleValidators::SingleField->new();
        fail('An exception was expected when trying to construct without a field_selector specification');
    }
    catch {
        pass('Exception received when trying to construct without a field_selector specification');
    };

    try {
        FormValidator::RuleValidators::SingleField->new(field_selector => {field_name_regex => '.*my-field'});
        my @value_validators = (
            {
                class => 'FormValidator::FieldValueValidators::NonEmpty',
            }
        );
        FormValidator::RuleValidators::SingleField->new(field_selector => {field_name => 'my-field'}, value_validators => \@value_validators);
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_rule_validator = FormValidator::RuleValidators::SingleField->new(field_selector => {field_name_regex => '.*my-field'});

    isa_ok($field_rule_validator, 'FormValidator::AbstractRuleValidator');
    isa_ok($field_rule_validator, 'FormValidator::RuleValidators::SingleField');

    return;
}

sub test_reflective_construction {
    try {
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::SingleField');
        fail('An exception was expected when trying to construct without a field_selector specification');
    }
    catch {
        pass('Exception received when trying to construct without a field_selector specification');
    };

    try {
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::SingleField', field_selector => {field_name_regex => '.*my-field'});
        my @value_validators = (
            {
                class => 'FormValidator::FieldValueValidators::NonEmpty',
            }
        );
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::SingleField', field_selector => {field_name => 'my-field'}, value_validators => \@value_validators);
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_rule_validator = FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::SingleField', field_selector => {field_name_regex => '.*my-field'});

    isa_ok($field_rule_validator, 'FormValidator::AbstractRuleValidator');
    isa_ok($field_rule_validator, 'FormValidator::RuleValidators::SingleField');

    return;
}

sub test_validation {
    my $field_rule_validator;
    my %form_data = (
        'empty-field' => undef, 
        'spaces-field' => q{ }, 
        'normal-field' => 'Lorem ipsum', 
    );
    my @value_validators;
    my ($ok, @messages);

    @value_validators = (
        {
            class => 'FormValidator::FieldValueValidators::NonEmpty', 
        }
    );
    $field_rule_validator = FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::SingleField', field_selector => {field_name_regex => '^(?:empty|spaces)-field$'}, value_validators => \@value_validators);
    ($ok, @messages) = $field_rule_validator->Validate(%form_data);
    ok(!$ok, "Empty or spaced fields should have a value");
    $field_rule_validator = FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::SingleField', field_selector => {field_name => 'normal-field'}, value_validators => \@value_validators);
    ($ok, @messages) = $field_rule_validator->Validate(%form_data);
    ok($ok, "Normal field has a value");

    return;
}

subtest 'Construction' => sub {
    test_construction();
    test_reflective_construction();

    done_testing();
};

subtest 'Validation' => sub {
    test_validation();

    done_testing();
};

done_testing();

1;
