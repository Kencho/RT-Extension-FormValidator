package t::FieldValueValidators::IsNumeric;

use strict;
use warnings;

use Test::More;
use Devel::Cover;
use Try::Tiny;

require_ok('FormValidator::AbstractFieldValueValidator');
require_ok('FormValidator::FieldValueValidators::IsNumeric');

sub test_construction {
    try {
        FormValidator::FieldValueValidators::IsNumeric->new();
    }
    catch {
        fail('An exception was not expected when trying to construct without arguments');
    };

    try {
        FormValidator::FieldValueValidators::IsNumeric->new(integer_only => 0);
        FormValidator::FieldValueValidators::IsNumeric->new(integer_only => 1);
        FormValidator::FieldValueValidators::IsNumeric->new(positive_only => 0);
        FormValidator::FieldValueValidators::IsNumeric->new(positive_only => 1);
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_value_validator = FormValidator::FieldValueValidators::IsNumeric->new();

    isa_ok($field_value_validator, 'FormValidator::AbstractFieldValueValidator');
    isa_ok($field_value_validator, 'FormValidator::FieldValueValidators::IsNumeric');
    is(0, $field_value_validator->IntegerOnly(), "Decimals accepted by default");
    is(0, $field_value_validator->PositiveOnly(), "Negatives accepted by default");

    return;
}

sub test_reflective_construction {
    try {
        FormValidator::AbstractFieldValueValidator::Build('FormValidator::FieldValueValidators::IsNumeric');
    }
    catch {
        fail('An exception was not expected when trying to construct without arguments');
    };

    try {
        FormValidator::AbstractFieldValueValidator::Build('FormValidator::FieldValueValidators::IsNumeric', integer_only => 0);
        FormValidator::AbstractFieldValueValidator::Build('FormValidator::FieldValueValidators::IsNumeric', integer_only => 1);
        FormValidator::AbstractFieldValueValidator::Build('FormValidator::FieldValueValidators::IsNumeric', positive_only => 0);
        FormValidator::AbstractFieldValueValidator::Build('FormValidator::FieldValueValidators::IsNumeric', positive_only => 1);
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_value_validator = FormValidator::AbstractFieldValueValidator::Build('FormValidator::FieldValueValidators::IsNumeric');

    isa_ok($field_value_validator, 'FormValidator::AbstractFieldValueValidator');
    isa_ok($field_value_validator, 'FormValidator::FieldValueValidators::IsNumeric');
    is(0, $field_value_validator->IntegerOnly(), "Decimals accepted by default");
    is(0, $field_value_validator->PositiveOnly(), "Negatives accepted by default");

    return;
}

sub test_field_value_validate_sign {
    my $field_value_validator;
    my ($ok, @messages);
    my $value;

    $field_value_validator = FormValidator::FieldValueValidators::IsNumeric->new();
    $field_value_validator->SetPositiveOnly(0);
    $value = undef;
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "An undefined field value should pass");
    $value = q{};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "An empty field value should pass");
    $value = '0';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '0.00';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '+123';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '+123.456e78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '-123';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '-123.456e78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = q{+};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = q{-};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");

    $field_value_validator->SetPositiveOnly(1);
    $value = undef;
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "An undefined field value should pass");
    $value = q{};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "An empty field value should pass");
    $value = '0';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '0.00';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '+123';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '+123.456e78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '-123';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = '-123.456e78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = q{+};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = q{-};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");

    return;
}

sub test_field_value_validate_precision {
    my $field_value_validator;
    my ($ok, @messages);
    my $value;

    $field_value_validator = FormValidator::FieldValueValidators::IsNumeric->new();
    $field_value_validator->SetIntegerOnly(0);
    $value = undef;
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "An undefined field value should pass");
    $value = q{};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "An empty field value should pass");
    $value = '0';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '0.00';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '+123';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '-.5';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '+5.';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '+123.456e78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '+123.456e+78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '+123.456e-78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '-123';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '-123.456e78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '-123.456e+78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '-123.456e-78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = q{+};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = q{-};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");

    $field_value_validator->SetIntegerOnly(1);
    $value = undef;
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "An undefined field value should pass");
    $value = q{};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "An empty field value should pass");
    $value = '0';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '0.00';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = '+123';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '-.5';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = '+5.';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = '+123.456e78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = '+123.456e+78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = '+123.456e-78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = '-123';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok($ok, "A $value field value should pass");
    $value = '-123.456e78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = '-123.456e+78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = '-123.456e-78';
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = q{+};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");
    $value = q{-};
    ($ok, @messages) = $field_value_validator->Validate($value, 'my-field');
    ok(!$ok, "A $value field value should not pass");

    return;
}

subtest 'Construction' => sub {
    test_construction();
    test_reflective_construction();

    done_testing();
};

subtest 'Validation' => sub {
    test_field_value_validate_sign();
    test_field_value_validate_precision();

    done_testing();
};

done_testing();

1;
