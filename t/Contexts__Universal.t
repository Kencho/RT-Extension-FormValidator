package t::Contexts::Universal;

use strict;
use warnings;

use Test::More;
use Devel::Cover;
use Try::Tiny;

require_ok('FormValidator::AbstractContext');
require_ok('FormValidator::Contexts::Universal');

sub test_construction {
    try {
        FormValidator::Contexts::Universal->new();
    }
    catch {
        fail('No exception was expected when trying to construct without arguments');
    };

    try {
        FormValidator::Contexts::Universal->new(queue_id => 123);
    }
    catch {
        fail('No exception was expected when trying to construct with arguments');
    };

    my $universal_context = FormValidator::Contexts::Universal->new();

    isa_ok($universal_context, 'FormValidator::AbstractContext');
    isa_ok($universal_context, 'FormValidator::Contexts::Universal');
    is($universal_context->Inverted(), 0, 'Not inverted by default');

    return;
}

sub test_reflective_construction {
    try {
        FormValidator::AbstractContext::Build('FormValidator::Contexts::Universal');
    }
    catch {
        fail('No exception was expected when trying to construct without arguments');
    };

    try {
        FormValidator::AbstractContext::Build('FormValidator::Contexts::Universal', queue_id => 123);
    }
    catch {
        fail('No exception was expected when trying to construct with arguments');
    };

    my $universal_context = FormValidator::AbstractContext::Build('FormValidator::Contexts::Universal');

    isa_ok($universal_context, 'FormValidator::AbstractContext');
    isa_ok($universal_context, 'FormValidator::Contexts::Universal');
    is($universal_context->Inverted(), 0, 'Not inverted by default');

    return;
}

sub test_checking {
    my $universal_context = FormValidator::Contexts::Universal->new();
    my $inverted_universal_context = FormValidator::Contexts::Universal->new(inverted => 1);

    is($universal_context->Check(), 1, "Context checking is always expected to pass");
    is($inverted_universal_context->Check(), 0, "Inverted context checking is never expected to pass");

    return;
}

sub test_parameterless_check {
    my $universal_context = FormValidator::Contexts::Universal->new();

    try {
        $universal_context->Check();
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
