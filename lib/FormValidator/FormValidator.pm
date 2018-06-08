=pod

=head1 NAME

FormValidator::FormValidator

The core validation class.

=cut

package FormValidator::FormValidator;

use strict;
use warnings;
use English qw(-no_match_vars);

use JSON;
use Try::Tiny;

use RT::Config;

use FormValidator::AbstractContext;

=pod

=head2 Methods

=cut

=pod

=head3 new()

The class constructor.

B<Note>

Call this from a class/module context, not from an existing instance. I.e., C<FormValidator::FormValidator-E<gt>new();> is ok, C<$my_form_validator-E<gt>new();> is not.

=cut

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->_Init(@_);
    return $self;
}

sub _Init {
    my $self = shift;

    $self->LoadRules();

    return;
}

=pod

=head3 Validate($action, $queue_id, $form_data)

Validates the form data in a given context (action and queue).

B<Parameters>

=over 1

=item C<$action> (string)

The form action (e.g., C<'Ticket/Create'>, C<'Ticket/Update'>).

=item C<$queue_id> (integer|string)

The queue identifier number or name.

=item C<$form_data> (hashref)

The hash reference with the form data.

=back

B<Returns>

A list of values:

=over 1

=item C<$ok>

C<1> (true) on success, C<0> (false) on error.

=back

=cut

sub Validate {
    my $self = shift;
    my $action = shift;
    my $queue_id = shift;
    my $form_data = shift;

    my $result = 1;

    if (!defined $self->{ruleset}) {
        return $result;
    }

    # TODO: Implement the actual validation logic.

    return $result;
}

=pod

=head3 LoadRules()

Loads the ruleset from the configured directory.

=cut

sub LoadRules {
    my $self = shift;

    my @ruleset;

    my $rules_dir = RT::Config->Get('form_validator_rules_dir');

    RT::Logger->debug(__PACKAGE__ . "::LoadConfig: Scanning configuration files from $rules_dir");

    if (defined $rules_dir && -r -d $rules_dir) {
        opendir(DH, $rules_dir);
        my @rules_files = readdir(DH);
        closedir(DH);

        foreach my $rules_file (@rules_files) {
            # Ignore . and .. entries.
            if ($rules_file =~ /^\.\.?$/xms) {
                next;
            }
            $rules_file = "$rules_dir/$rules_file";
            RT::Logger->debug(__PACKAGE__ . "::LoadConfig: Parsing configuration from $rules_file");

            try {
                push @ruleset, $self->_LoadRulesFromFile($rules_file);
            }
            catch {
                RT::Logger->error(__PACKAGE__ . "::LoadConfig: Errors reading configuration from $rules_file. Reason: $_");
            };
        }
    }

    undef $self->{ruleset};
    $self->{ruleset} = \@ruleset;

    return;
}

=pod

=head3 _LoadRulesFromFile($rules_file)

Loads the rules in an specific file.

B<Note>

Internal function. Do not use from outside of this module.

B<Parameters>

=over 1

=item C<$rules_file>

The JSON file with the rules to add.

=back

B<Returns>

A list of elements loaded from the file, or nothing on error.

=cut

sub _LoadRulesFromFile {
    my $self = shift;
    my $rules_file = shift;

    if (!(defined $rules_file && -f -r $rules_file)) {
        RT::Logger->warning(__PACKAGE__ . "::_LoadRulesFromFile: \$rules_file $rules_file is not defined or readable");
        return;
    }

    my $file_handle;
    my $file_contents = do {
        if (!open($file_handle, "<:encoding(UTF-8)", $rules_file)) {
            RT::Logger->warning(__PACKAGE__ . "::_LoadRulesFromFile: Couldn't open $rules_file: $OS_ERROR");
            return;
        }
        local $INPUT_RECORD_SEPARATOR;
        <$file_handle>
    };
    close($file_handle) or die "Unable to close $rules_file: $OS_ERROR\n";

    my $rules_data;
    try {
        $rules_data = JSON->new()->decode($file_contents);
    }
    catch {
        RT::Logger->warning(__PACKAGE__ . "::_LoadRulesFromFile: $rules_file is not a valid JSON file. Reason: $_");
    };

    if (defined $rules_data) {
        RT::Logger->debug(__PACKAGE__ . "::_LoadRulesFromFile: Data read from $rules_file: " . Data::Dumper::Dumper($rules_data));

        my @rules_data;
        if (ref $rules_data eq 'ARRAY') {
            @rules_data = @{$rules_data};
        }
        else {
            @rules_data = ($rules_data);
        }

        my @rules;

        foreach my $rule_data_ref (@rules_data) {
            my %rule;

            # Contexts
            my @contexts;
            if (exists $rule_data_ref->{contexts}) {
                push @contexts, $self->_BuildContextsFromData($rule_data_ref->{contexts});
            }
            else {
                push @contexts, (FormValidator::Contexts::Universal->new());
            }
            $rule{contexts} = \@contexts;

            push @rules, {%rule};
        }

        RT::Logger->debug(__PACKAGE__ . "::_LoadRulesFromFile: Rules: " . Data::Dumper::Dumper(\@rules));

        return @rules;
    }

    return;
}

=pod

=head3 _BuildContextsFromData($contexts_data_ref)

Builds an array of context objects from data (e.g., loaded from the configuration files).

B<Note>

Internal function. Do not use from outside of this module.

B<Parameters>

=over 1

=item C<$contexts_data_ref> (arrayref|hashref)

The data to build one (i.e. hashref) or several (i.e. arrayref) contexts.

=back

B<Returns>

An array of contexts created using the data.

=cut

sub _BuildContextsFromData {
    my $self = shift;
    my $contexts_data_ref = shift;

    my @contexts;

    my @contexts_data;
    if (ref $contexts_data_ref eq 'ARRAY') {
        @contexts_data = @{$contexts_data_ref};
    }
    else {
        @contexts_data = ($contexts_data_ref);
    }

    foreach my $context_data_ref (@contexts_data) {
        push @contexts, $self->_BuildContextFromData($context_data_ref);
    }

    return @contexts;
}

=pod

=head3 _BuildContextFromData($context_data_ref)

Builds a context object from data (e.g., loaded from the configuration files).

B<Note>

Internal function. Do not use from outside of this module.

B<Parameters>

=over 1

=item C<$context_data_ref> (hashref)

The data to build a single context.

=back

B<Returns>

A context object created using the data.

=cut

sub _BuildContextFromData {
    my $self = shift;
    my $context_data_ref = shift;

    if (!exists $context_data_ref->{class}) {
        die "A 'class' attribute is required to instantiate a context.\n" . Data::Dumper::Dumper($context_data_ref) . "\n";
    }

    return FormValidator::AbstractContext::Build($context_data_ref->{class}, %{$context_data_ref->{args}});
}

1;
