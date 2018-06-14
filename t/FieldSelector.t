package t::FieldSelector;

use strict;
use warnings;

use Test::More;
use Devel::Cover;
use Try::Tiny;

require_ok('FormValidator::FieldSelector');

sub test_construction {
    try {
        FormValidator::FieldSelector->new();
    }
    catch {
        fail('No exception was expected when trying to construct without arguments');
    };

    try {
        FormValidator::FieldSelector->new(field_name_regex => '.*my-field');
        FormValidator::FieldSelector->new(field_name => 'my-field');
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_selector = FormValidator::FieldSelector->new(field_name_regex => '.*my-field');

    isa_ok($field_selector, 'FormValidator::FieldSelector');

    return;
}

sub test_reflective_construction {
    try {
        FormValidator::FieldSelector::Build();
    }
    catch {
        fail('No exception was expected when trying to construct without arguments');
    };

    try {
        FormValidator::FieldSelector::Build({field_name_regex => '.*my-field'});
        FormValidator::FieldSelector::Build({field_name => 'my-field'});
    }
    catch {
        fail('No exception was expected when trying to construct with the right arguments');
    };

    my $field_selector = FormValidator::FieldSelector::Build({field_name_regex => '.*my-field'});

    isa_ok($field_selector, 'FormValidator::FieldSelector');

    return;
}

sub test_field_name_regex_checking {
    my $field_regex_name_selector;
    my $regex;

    $regex = q{simple};
    $field_regex_name_selector = FormValidator::FieldSelector->new(field_name_regex => $regex);
    ok($field_regex_name_selector->Matches("simple"), "Matches regex");
    ok($field_regex_name_selector->Matches("A bit less simple name"), "Matches regex");
    ok(!$field_regex_name_selector->Matches("complex"), "Doesn't match regex");
    $regex = q{.*my-field\s+name with spaces};
    $field_regex_name_selector = FormValidator::FieldSelector->new(field_name_regex => $regex);
    ok($field_regex_name_selector->Matches("my-block-my-field\tname with spaces"), "Matches regex");
    $regex = q{^Strictly$};
    $field_regex_name_selector = FormValidator::FieldSelector->new(field_name_regex => $regex);
    ok($field_regex_name_selector->Matches("Strictly"), "Matches regex");
    ok(!$field_regex_name_selector->Matches(" Strictly "), "Doesn't match regex");

    return;
}

sub test_field_name_checking {
    my $field_name_selector;
    my $name;

    $name = q{simple};
    $field_name_selector = FormValidator::FieldSelector->new(field_name => $name);
    ok($field_name_selector->Matches("simple"), "Matches name");
    ok(!$field_name_selector->Matches("Simple"), "Doesn't match casing");
    $name = q{A name with Spaces, punctuation, and Öthers};
    $field_name_selector = FormValidator::FieldSelector->new(field_name => $name);
    ok($field_name_selector->Matches("A name with Spaces, punctuation, and Öthers"), "Matches name");

    return;
}

sub test_null_checking {
    my $field_null_selector;

    $field_null_selector = FormValidator::FieldSelector->new();
    ok(!$field_null_selector->Matches("Whatever"), "Should never pass");
    ok(!$field_null_selector->Matches(q{}), "Should never pass");
    ok(!$field_null_selector->Matches(), "Should never pass");

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
    test_null_checking();

    done_testing();
};

done_testing();

1;
