package t::Contexts::Queue;

use strict;
use warnings;

use Test::More;
use Devel::Cover;
use Try::Tiny;

require_ok('FormValidator::AbstractContext');
require_ok('FormValidator::Contexts::Queue');

sub test_construction {
    try {
        FormValidator::Contexts::Queue->new();
        fail('An exception was expected when trying to construct without a queue id');
    }
    catch {
        pass('Exception captured when trying to construct without a queue id');
    };

    try {
        FormValidator::Contexts::Queue->new(queue_id => undef);
        fail('An exception was expected when trying to construct with an undefined queue id');
    }
    catch {
        pass('Exception captured when trying to construct without an undefined queue id');
    };

    my $queue_context = FormValidator::Contexts::Queue->new(queue_id => 235);

    isa_ok($queue_context, 'FormValidator::AbstractContext');
    isa_ok($queue_context, 'FormValidator::Contexts::Queue');
    is($queue_context->Inverted(), 0, 'Not inverted by default');

    return;
}

sub test_reflective_construction {
    try {
        FormValidator::AbstractContext::Build('FormValidator::Contexts::Queue');
        fail('An exception was expected when trying to construct without a queue id');
    }
    catch {
        pass('Exception captured when trying to construct without a queue id');
    };

    try {
        FormValidator::AbstractContext::Build('FormValidator::Contexts::Queue', queue_id => undef);
        fail('An exception was expected when trying to construct with an undefined queue id');
    }
    catch {
        pass('Exception captured when trying to construct without an undefined queue id');
    };

    my $queue_context = FormValidator::AbstractContext::Build('FormValidator::Contexts::Queue', queue_id => 235);

    isa_ok($queue_context, 'FormValidator::AbstractContext');
    isa_ok($queue_context, 'FormValidator::Contexts::Queue');
    is($queue_context->Inverted(), 0, 'Not inverted by default');

    return;
}

sub test_parameterless_check {
    my $queue_context = FormValidator::Contexts::Queue->new(queue_id => 235);

    try {
        $queue_context->Check();
        fail('An exception was expected when checking without a queue_id argument');
    }
    catch {
        pass('Exception captured when checking without a queue_id argument');
    };
    try {
        $queue_context->Check(queue_id => undef);
        fail('An exception was expected when checking with an undefined queue_id argument');
    }
    catch {
        pass('Exception captured when checking with an undefined queue_id argument');
    };

    return;
}

sub test_id_numbers {
    my $queue_context = FormValidator::Contexts::Queue->new(queue_id => 235);

    is($queue_context->Check(queue_id => 235), 1, "Queue #235 is a valid context");
    is($queue_context->Check(queue_id => 75), 0, "Queue #75 is not a valid context");
    is($queue_context->Check(queue_id => 'Queue name'), 0, "Queue 'Queue name' is not a valid context");

    return;
}

sub test_inverted_id_numbers {
    my $queue_context = FormValidator::Contexts::Queue->new(queue_id => 235);
    $queue_context->SetInverted(1);

    is($queue_context->Check(queue_id => 235), 0, "Queue #235 is not a valid context");
    is($queue_context->Check(queue_id => 75), 1, "Queue #75 is a valid context");
    is($queue_context->Check(queue_id => 'Queue name'), 1, "Queue 'Queue name' is a valid context");

    return;
}

sub test_id_names {
    my $queue_id_number = 1;
    my $queue_id_name = 'My queue Name';
    my $queue_context = FormValidator::Contexts::Queue->new(queue_id => $queue_id_name);

    is($queue_context->Check(queue_id => $queue_id_name), 1, "Queue '$queue_id_name' is a valid context");
    is($queue_context->Check(queue_id => "Another $queue_id_name"), 0, "Queue 'Another $queue_id_name' is not a valid context");
    is($queue_context->Check(queue_id => $queue_id_number), 0, "Queue #$queue_id_number is not a valid context");

    return;
}

sub test_inverted_id_names {
    my $queue_id_number = 1;
    my $queue_id_name = 'My queue Name';
    my $queue_context = FormValidator::Contexts::Queue->new(queue_id => $queue_id_name);
    $queue_context->SetInverted(1);

    is($queue_context->Check(queue_id => $queue_id_name), 0, "Queue '$queue_id_name' is not a valid context");
    is($queue_context->Check(queue_id => "Another $queue_id_name"), 1, "Queue 'Another $queue_id_name' is a valid context");
    is($queue_context->Check(queue_id => $queue_id_number), 1, "Queue #$queue_id_number is a valid context");

    return;
}

subtest 'Construction' => sub {
    test_construction();
    test_reflective_construction();

    done_testing();
};

subtest 'Parameterless checking' => sub {
    test_parameterless_check();

    done_testing();
};

subtest 'Normal id numbers' => sub {
    test_id_numbers();

    done_testing();
};

subtest 'Inverted id numbers' => sub {
    test_inverted_id_numbers();

    done_testing();
};

subtest 'Normal id names' => sub {
    test_id_names();

    done_testing();
};

subtest 'Inverted id names' => sub {
    test_inverted_id_names();

    done_testing();
};

done_testing();

1;
