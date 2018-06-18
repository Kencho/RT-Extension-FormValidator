package t::FieldValueValidators::NonEmpty;

use strict;
use warnings;

use Test::More;
use Devel::Cover;
use Try::Tiny;

require_ok('FormValidator::AbstractFieldValueValidator');
require_ok('FormValidator::FieldValueValidators::NonEmpty');

sub test_construction {
    try {
        FormValidator::FieldValueValidators::NonEmpty->new();
    }
    catch {
        fail('An exception was not expected when trying to construct without arguments');
    };

    try {
        FormValidator::FieldValueValidators::NonEmpty->new(trim_spaces => 0);
        FormValidator::FieldValueValidators::NonEmpty->new(trim_spaces => 1);
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_value_validator = FormValidator::FieldValueValidators::NonEmpty->new();

    isa_ok($field_value_validator, 'FormValidator::AbstractFieldValueValidator');
    isa_ok($field_value_validator, 'FormValidator::FieldValueValidators::NonEmpty');

    return;
}

sub test_reflective_construction {
    try {
        FormValidator::AbstractFieldValueValidator::Build('FormValidator::FieldValueValidators::NonEmpty');
    }
    catch {
        fail('An exception was not expected when trying to construct without arguments');
    };

    try {
        FormValidator::AbstractFieldValueValidator::Build('FormValidator::FieldValueValidators::NonEmpty', trim_spaces => 0);
        FormValidator::AbstractFieldValueValidator::Build('FormValidator::FieldValueValidators::NonEmpty', trim_spaces => 1);
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_value_validator = FormValidator::AbstractFieldValueValidator::Build('FormValidator::FieldValueValidators::NonEmpty');

    isa_ok($field_value_validator, 'FormValidator::AbstractFieldValueValidator');
    isa_ok($field_value_validator, 'FormValidator::FieldValueValidators::NonEmpty');

    return;
}

sub test_field_value_validate_trimming {
    my $field_value_validator;
    my ($ok, @messages);

    $field_value_validator = FormValidator::FieldValueValidators::NonEmpty->new();
    ok($field_value_validator->TrimSpaces(), "Spaces should be trimmed by default");
    ($ok, @messages) = $field_value_validator->Validate(undef, 'my-field');
    ok(!$ok, "An undefined field value should fail");
    ($ok, @messages) = $field_value_validator->Validate(q{}, 'my-field');
    ok(!$ok, "An empty field value should fail");
    ($ok, @messages) = $field_value_validator->Validate(q{   }, 'my-field');
    ok(!$ok, "A spaces-only field value should fail by default");
    ($ok, @messages) = $field_value_validator->Validate('  my-value  ', 'my-field');
    ok($ok, "An non-empty field value should pass");

    return;
}

sub test_field_value_validate_no_trimming {
    my $field_value_validator;
    my ($ok, @messages);

    $field_value_validator = FormValidator::FieldValueValidators::NonEmpty->new(trim_spaces => 0);
    ok(!$field_value_validator->TrimSpaces(), "Spaces should not be trimmed");
    ($ok, @messages) = $field_value_validator->Validate(undef, 'my-field');
    ok(!$ok, "An undefined field value should fail");
    ($ok, @messages) = $field_value_validator->Validate(q{}, 'my-field');
    ok(!$ok, "An empty field value should fail");
    ($ok, @messages) = $field_value_validator->Validate(q{   }, 'my-field');
    ok($ok, "A spaces-only field value should not fail if spaces aren't trimmed");
    ($ok, @messages) = $field_value_validator->Validate('  my-value  ', 'my-field');
    ok($ok, "An non-empty field value should pass");

    return;
}

subtest 'Construction' => sub {
    test_construction();
    test_reflective_construction();

    done_testing();
};

subtest 'Validation' => sub {
    test_field_value_validate_trimming();
    test_field_value_validate_no_trimming();

    done_testing();
};

done_testing();

1;
