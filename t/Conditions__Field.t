package t::Conditions::Field;

use strict;
use warnings;

use Test::More;
use Devel::Cover;
use Try::Tiny;

require_ok('FormValidator::AbstractCondition');
require_ok('FormValidator::Conditions::Field');

sub test_construction {
    try {
        FormValidator::Conditions::Field->new();
        fail('An exception was expected when trying to construct without either field_name or field_name_regex');
    }
    catch {
        pass('Exception received when trying to construct without either field_name or field_name_regex');
    };

    try {
        FormValidator::Conditions::Field->new(field_name_regex => '.*my-field');
        FormValidator::Conditions::Field->new(field_name => 'my-field');
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_condition = FormValidator::Conditions::Field->new(field_name_regex => '.*my-field');

    isa_ok($field_condition, 'FormValidator::AbstractCondition');
    isa_ok($field_condition, 'FormValidator::Conditions::Field');

    return;
}

sub test_reflective_construction {
    try {
        FormValidator::AbstractCondition::Build('FormValidator::Conditions::Field');
        fail('An exception was expected when trying to construct without either field_name or field_name_regex');
    }
    catch {
        pass('Exception received when trying to construct without either field_name or field_name_regex');
    };

    try {
        FormValidator::AbstractCondition::Build('FormValidator::Conditions::Field', field_name_regex => '.*my-field');
        FormValidator::AbstractCondition::Build('FormValidator::Conditions::Field', field_name => 'my-field');
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_condition = FormValidator::AbstractCondition::Build('FormValidator::Conditions::Field', field_name_regex => '.*my-field');

    isa_ok($field_condition, 'FormValidator::AbstractCondition');
    isa_ok($field_condition, 'FormValidator::Conditions::Field');

    return;
}

sub test_field_name_regex_checking {
    my $field_regex_name_condition;
    my $regex;

    $regex = q{simple};
    $field_regex_name_condition = FormValidator::Conditions::Field->new(field_name_regex => $regex);
    ok($field_regex_name_condition->Check(field_name => "simple"), "Matches regex");
    ok($field_regex_name_condition->Check(field_name => "A bit less simple name"), "Matches regex");
    ok(!$field_regex_name_condition->Check(field_name => "complex"), "Doesn't match regex");
    $regex = q{.*my-field\s+name with spaces};
    $field_regex_name_condition = FormValidator::Conditions::Field->new(field_name_regex => $regex);
    ok($field_regex_name_condition->Check(field_name => "my-block-my-field\tname with spaces"), "Matches regex");
    $regex = q{^Strictly$};
    $field_regex_name_condition = FormValidator::Conditions::Field->new(field_name_regex => $regex);
    ok($field_regex_name_condition->Check(field_name => "Strictly"), "Matches regex");
    ok(!$field_regex_name_condition->Check(field_name => " Strictly "), "Doesn't match regex");

    return;
}

sub test_field_name_checking {
    my $field_name_condition;
    my $name;

    $name = q{simple};
    $field_name_condition = FormValidator::Conditions::Field->new(field_name => $name);
    ok($field_name_condition->Check(field_name => "simple"), "Matches name");
    ok(!$field_name_condition->Check(field_name => "Simple"), "Doesn't match casing");
    $name = q{A name with Spaces, punctuation, and Öthers};
    $field_name_condition = FormValidator::Conditions::Field->new(field_name => $name);
    ok($field_name_condition->Check(field_name => "A name with Spaces, punctuation, and Öthers"), "Matches name");

    return;
}

subtest 'Construction' => sub {
    test_construction();
    test_reflective_construction();

    done_testing();
};

subtest 'Checking' => sub {
    test_field_name_regex_checking();
    test_field_name_checking();

    done_testing();
};

done_testing();

1;
