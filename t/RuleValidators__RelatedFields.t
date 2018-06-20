package t::RuleValidators::RelatedFields;

use strict;
use warnings;

use Test::More;
use Devel::Cover;
use Try::Tiny;

require_ok('FormValidator::AbstractRuleValidator');
require_ok('FormValidator::RuleValidators::RelatedFields');

sub test_construction {
    try {
        FormValidator::RuleValidators::RelatedFields->new();
        fail('An exception was expected when trying to construct without a master_field_selector and slave_field_selector specification');
    }
    catch {
        pass('Exception received when trying to construct without a master_field_selector and slave_field_selector specification');
    };
    try {
        FormValidator::RuleValidators::RelatedFields->new(master_field_selector => {field_name_regex => '.*my-field'});
        fail('An exception was expected when trying to construct without a slave_field_selector specification');
    }
    catch {
        pass('Exception received when trying to construct without a slave_field_selector specification');
    };
    try {
        FormValidator::RuleValidators::RelatedFields->new(slave_field_selector => {field_name_regex => '.*my-field'});
        fail('An exception was expected when trying to construct without a master_field_selector specification');
    }
    catch {
        pass('Exception received when trying to construct without a master_field_selector specification');
    };

    try {
        FormValidator::RuleValidators::RelatedFields->new(master_field_selector => {field_name_regex => '.*my-field'}, slave_field_selector => {field_name_regex => '.*my-dependent-field'});
        my @master_value_conditions = (
            {
                class => 'FormValidator::FieldValueValidators::NonEmpty',
            }
        );
        my @slave_value_validators = (
            {
                class => 'FormValidator::FieldValueValidators::NonEmpty',
            }
        );
        FormValidator::RuleValidators::RelatedFields->new(master_field_selector => {field_name => 'my-field'}, slave_field_selector => {field_name_regex => '.*my-dependent-field'}, master_value_conditions => \@master_value_conditions, slave_value_validators => \@slave_value_validators);
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_rule_validator = FormValidator::RuleValidators::RelatedFields->new(master_field_selector => {field_name_regex => '.*my-field'}, slave_field_selector => {field_name_regex => '.*my-dependent-field'});

    isa_ok($field_rule_validator, 'FormValidator::AbstractRuleValidator');
    isa_ok($field_rule_validator, 'FormValidator::RuleValidators::RelatedFields');

    return;
}

sub test_reflective_construction {
    try {
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::RelatedFields');
        fail('An exception was expected when trying to construct without a master_field_selector and slave_field_selector specification');
    }
    catch {
        pass('Exception received when trying to construct without a master_field_selector and slave_field_selector specification');
    };
    try {
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::RelatedFields', master_field_selector => {field_name_regex => '.*my-field'});
        fail('An exception was expected when trying to construct without a slave_field_selector specification');
    }
    catch {
        pass('Exception received when trying to construct without a slave_field_selector specification');
    };
    try {
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::RelatedFields', slave_field_selector => {field_name_regex => '.*my-field'});
        fail('An exception was expected when trying to construct without a master_field_selector specification');
    }
    catch {
        pass('Exception received when trying to construct without a master_field_selector specification');
    };

    try {
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::RelatedFields', master_field_selector => {field_name_regex => '.*my-field'}, slave_field_selector => {field_name_regex => '.*my-dependent-field'});
        my @master_value_conditions = (
            {
                class => 'FormValidator::FieldValueValidators::NonEmpty',
            }
        );
        my @slave_value_validators = (
            {
                class => 'FormValidator::FieldValueValidators::NonEmpty',
            }
        );
        FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::RelatedFields', master_field_selector => {field_name => 'my-field'}, slave_field_selector => {field_name => 'my-dependent-field'}, master_value_conditions => \@master_value_conditions, slave_value_validators => \@slave_value_validators);
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_rule_validator = FormValidator::AbstractRuleValidator::Build('FormValidator::RuleValidators::RelatedFields', master_field_selector => {field_name_regex => '.*my-field'}, slave_field_selector => {field_name_regex => '.*my-dependent-field'});

    isa_ok($field_rule_validator, 'FormValidator::AbstractRuleValidator');
    isa_ok($field_rule_validator, 'FormValidator::RuleValidators::RelatedFields');

    return;
}

sub test_validation {
    my $field_rule_validator;
    my %form_data = (
        'master-1' => undef, 
        'slave-1' => undef, 
        'master-2' => 'Lorem ipsum', 
        'slave-2' => undef, 
        'master-3' => undef, 
        'slave-3' => 'dolor sit amet', 
        'master-4' => 'Lorem ipsum', 
        'slave-4' => 'dolor sit amet', 
    );
    my ($ok, @messages);

    my @nonempty_values = (
        {
            class => 'FormValidator::FieldValueValidators::NonEmpty', 
        }
    );
    $field_rule_validator = FormValidator::AbstractRuleValidator::Build(
        'FormValidator::RuleValidators::RelatedFields', 
        master_field_selector => {
            field_name => 'master-1'
        }, 
        slave_field_selector => {
            field_name => 'slave-1'
        }, 
    );
    ($ok, @messages) = $field_rule_validator->Validate(%form_data);
    ok($ok, "Pass when no specific validation is enforced");
    $field_rule_validator = FormValidator::AbstractRuleValidator::Build(
        'FormValidator::RuleValidators::RelatedFields', 
        master_field_selector => {
            field_name => 'master-1'
        }, 
        master_value_conditions => \@nonempty_values, 
        slave_field_selector => {
            field_name => 'slave-1'
        }, 
        slave_value_validators => \@nonempty_values, 
    );
    ($ok, @messages) = $field_rule_validator->Validate(%form_data);
    ok($ok, "slave-1 doesn't have a value, but it's okay as master-1 doesn't have either");
    $field_rule_validator = FormValidator::AbstractRuleValidator::Build(
        'FormValidator::RuleValidators::RelatedFields', 
        master_field_selector => {
            field_name => 'master-2'
        }, 
        master_value_conditions => \@nonempty_values, 
        slave_field_selector => {
            field_name => 'slave-2'
        }, 
        slave_value_validators => \@nonempty_values, 
    );
    ($ok, @messages) = $field_rule_validator->Validate(%form_data);
    ok(!$ok, "slave-2 doesn't have a value, and that's not okay as master-2 has a value");
    $field_rule_validator = FormValidator::AbstractRuleValidator::Build(
        'FormValidator::RuleValidators::RelatedFields', 
        master_field_selector => {
            field_name => 'master-3'
        }, 
        master_value_conditions => \@nonempty_values, 
        slave_field_selector => {
            field_name => 'slave-3'
        }, 
        slave_value_validators => \@nonempty_values, 
    );
    ($ok, @messages) = $field_rule_validator->Validate(%form_data);
    ok($ok, "slave-3 has a value, but that doesn't matter as master-3 has not");
    $field_rule_validator = FormValidator::AbstractRuleValidator::Build(
        'FormValidator::RuleValidators::RelatedFields', 
        master_field_selector => {
            field_name => 'master-4'
        }, 
        master_value_conditions => \@nonempty_values, 
        slave_field_selector => {
            field_name => 'slave-4'
        }, 
        slave_value_validators => \@nonempty_values, 
    );
    ($ok, @messages) = $field_rule_validator->Validate(%form_data);
    ok($ok, "slave-4 has a value as required, as master-4 has one too");

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
