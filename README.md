# RT-Extension-FormValidator

An RT extension to perform customizable form validation

## Installation

Run the following commands:

```bash
perl Makefile.PL
make
make test # Optional. Runs the extension tests.
make install
```

## Configuration

This extension reads JSON configuration files from a directory configured in `$form_validator_rules_dir`.

It iterates every file in the directory (not recursively!) and tries to load the rules in them.

If the file contains only a single rule object, it will be appended to the loaded ruleset. If the file is an array of rules, all of them are appended to the ruleset.

### Rules files specification

Each rules file can have a single set of rules, or several sets.

The rulesets are hashmaps (dictionaries in JSON) containing optionally these two keys:

- `contexts`, describing the different contexts this ruleset will apply to. Can be only one context or a list if contexts. If validation is requested from any of these contexts, the rules in the set will be enforced. If omitted, an "universal" context will be used by default.
- `rule_validators`, describing the different rules that will be enforced on the form, if the context is valid. Can be only one rule validator or a list of validators. If omitted, no rule will be enforced.

The key to make it easily extensible and configurable is the use of reflection. Both the context and rule validator objects are specified as hashmaps/dictionaries, with at least one key: `class`. This contains the fully quallified name of the class to instantiate (subclasses of `AbstractContext` or `AbstractRuleValidator` for contexts or rule validators, respectively). See the API details of both classes to know how to extend them to implement your own. When instantiated, the extension will call the class' `new` method, passing the arguments hashmap/dictionary defined in the `args` field of the object specification.

## Tutorial

Once the extension is installed and the configuration rules directory is set up, it's time to use the extension.

First of all, setup a rules file in the configured directory. For instance:

```json
[
    {
        "contexts": [
            {
                "class": "FormValidator::Contexts::Queue", 
                "args": {
                    "queue_id": "Incidents"
                }
            },
            {
                "class": "FormValidator::Contexts::Queue", 
                "args": {
                    "queue_id": "Investigations"
                }
            }
        ], 
        "rule_validators": {
            "class": "FormValidator::RuleValidators::Always"
        }
    }, 
    {
        "contexts": {
            "class": "FormValidator::Contexts::Queue", 
            "args": {
                "queue_id": "Incident Reports"
            }
        }, 
        "rule_validators": [
            {
                "class": "Demo::FailValidator"
            }, 
            {
                "class": "Demo::FailValidator"
            }
        ]
    }
]
```

This file will define two sets of rules:

- A set that applies in two different contexts (queues 'Incidents' and 'Investigations'). In those contexts, the validation will always pass (we use a testing always-pass validator).
- A set that applies only to the queue 'Incident Reports' and enforces twice a testing always-fail validator.

These rules make no sense, but will be sufficient for demonstration purposes.

Secondly, we need to implement our `Demo::FailValidator` class. Place these contents in a file named `$RT_HOME/local/lib/Demo/FailValidator.pm`:

```perl
package Demo::FailValidator;

use parent 'FormValidator::AbstractRuleValidator';

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->_Init(@_);
    return $self;
}

sub _Init {
    my $self = shift;
    my %args = (
        @_, 
    );

    $self->SUPER::_Init(%args);

    return;
}

sub Validate {
    my $self = shift;
    my %form_data = (
        @_,
    );

    return (0, ('This failure was expected! (' . rand . ')'));
}

1;
```

The validator implements just the three essential parts: The `new` abstract method, the actual `_Init` constructor (that uses the parent's `_Init` method as well internally), and the method `Validate`, which contains the actual validation logic of this validator. In this case it will just fail and emit a semi-random message.

To complete this tutorial, we'll define a callback to invoke the validation. Paste these lines in a new file `$RT_HOME/local/html/Callbacks/Demo/Ticket/Create.html/BeforeCreate`:

```perl
<%init>
# Example Ticket/Create.html/BeforeCreate callback
use FormValidator::FormValidator;

my $queue_id = $ARGSRef->{Queue};
my $queue = RT::Queue->new(RT->SystemUser);
$queue->Load($queue_id);

my ($ok, @messages) = FormValidator::FormValidator->new()->Validate('Ticket/Create', $queue->Name(), $ARGSRef);

RT::Logger->debug("OK: $ok; Messages: " . Data::Dumper::Dumper(\@messages));

if (!$ok) {
    ${$skip_create} = 1;
    push @{$results}, @messages;
}
</%init>
<%args>
$ARGSRef => undef
$skip_create
$results => []
</%args>
```

The callback will be called both when someone attempts to actually create the ticket, or just when entering the ticket creation form. 

Then, it will take the queue and get its name (RT sometimes refers to the queue by its name and other times by its id, so we have to normalize this value; the name is preferred because a) the queues may have different ids in different instances, and b) we can use regular expressions to define the contexts). 

It will then instantiate the form validator and pass the form data and some context to it, requesting validation. The validator tries every ruleset against this form, enforcing the rules in those contexts that apply. As a result, we get a result value (`1` when validation passed, `0` if any rule didn't pass). If there are any rules that didn't pass, an array of messages with the reasons is passed as a second return value.

If the validation failed, this callback will:

- stop the creation process by setting `$skip_create` (passed by reference) to true (`1`), and 
- append the error messages to the `@results` (passed by reference) list.

With the given configuration, we should be able to work with Incidents and Investigations normally, but any attempt to create an Incident Report via the form will be aborted and two "_This failure was expected! (...)_" messages displayed.
