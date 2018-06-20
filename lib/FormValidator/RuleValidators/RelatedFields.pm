=pod

=head1 NAME

FormValidator::RuleValidators::RelatedFields

A base class for related fields rule validators.

A subclass of C<FormValidator::AbstractContext>

=cut

package FormValidator::RuleValidators::RelatedFields;

use strict;
use warnings;

use parent 'FormValidator::AbstractRuleValidator';

use FormValidator::FieldSelector;
use FormValidator::AbstractFieldValueValidator;

=pod

=head2 Methods

=cut

=pod

=head3 new()

The constructor.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments for the rule validator.

Required values are:

=over 2

=item C<master_field_selector> (hashref)

The specification (i.e., arguments dictionary) to instantiate a C<FormValidator::FieldSelector> object used to select the master fields to apply this rule on.

=item C<slave_field_selector> (hashref)

The specification (i.e., arguments dictionary) to instantiate a C<FormValidator::FieldSelector> object used to select the slave fields to apply this rule on.

=back

=back

=cut

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->_Init(@_);
    return $self;
}

=pod

=head3 _Init(%args)

Initialization method.

B<Note>

Don't override, as it initializes internal attributes. Instead, call it from the subclasses initializers using C<$self-E<gt>SUPER::_Init(%args)>

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments for the rule validator.

Required values are:

=over 2

=item C<master_field_selector> (hashref)

The specification (i.e., arguments dictionary) to instantiate a C<FormValidator::FieldSelector> object used to select the master fields to apply this rule on.

=item C<master_value_conditions> (listref of hashrefs)

The specification (i.e., arguments dictionary) to instantiate a list of C<FormValidator::AbstractFieldValueValidator> object used to validate the master fields this rule applies to.

=item C<slave_field_selector> (hashref)

The specification (i.e., arguments dictionary) to instantiate a C<FormValidator::FieldSelector> object used to select the slave fields to apply this rule on.

=item C<slave_value_validators> (listref of hashrefs)

The specification (i.e., arguments dictionary) to instantiate a list of C<FormValidator::AbstractFieldValueValidator> object used to validate the slave fields this rule applies to.

=back

=back

B<See also>

=over 1

=item C<FormValidator::AbstractContext> for details on other arguments.

=back

=cut

sub _Init {
    my $self = shift;
    my %args = (
        master_field_selector => undef, 
        master_value_conditions => undef, 
        slave_field_selector => undef, 
        slave_value_validators => undef, 
        @_, 
    );

    if (!defined $args{master_field_selector}) {
        die "An specification for the master field selector is required.\n";
    }
    if (!defined $args{slave_field_selector}) {
        die "An specification for the slave field selector is required.\n";
    }

    $self->SUPER::_Init(%args);

    $self->{master_field_selector} = FormValidator::FieldSelector::Build($args{master_field_selector});
    $self->{slave_field_selector} = FormValidator::FieldSelector::Build($args{slave_field_selector});
    my @master_value_conditions;
    if (defined $args{master_value_conditions}) {
        foreach my $master_value_condition_spec (@{$args{master_value_conditions}}) {
            my $master_value_condition = FormValidator::AbstractFieldValueValidator::Build($master_value_condition_spec->{class}, %{$master_value_condition_spec->{args}});
            push @master_value_conditions, $master_value_condition;
        }
    }
    $self->{master_value_conditions} = \@master_value_conditions;
    my @slave_value_validators;
    if (defined $args{slave_value_validators}) {
        foreach my $slave_value_validator_spec (@{$args{slave_value_validators}}) {
            my $slave_value_validator = FormValidator::AbstractFieldValueValidator::Build($slave_value_validator_spec->{class}, %{$slave_value_validator_spec->{args}});
            push @slave_value_validators, $slave_value_validator;
        }
    }
    $self->{slave_value_validators} = \@slave_value_validators;

    return;
}

=pod

=head3 Validate(%form_data)

Validates the form data using this related fields rule.

B<See>

C<FormValidator::AbstractRuleValidator::Validate> for additional details on this function.

=cut

sub Validate {
    my $self = shift;
    my %form_data = (
        @_, 
    );

    my $ok = 1;
    my @messages;
    my %master_filtered_form_data = $self->{master_field_selector}->Filter(%form_data);
    foreach my $master_field_name (keys %master_filtered_form_data) {
        my $master_field_ok = 1;
        my $master_field_value = $master_filtered_form_data{$master_field_name};
        foreach my $master_field_value_condition (@{$self->{master_value_conditions}}) {
            my ($field_ok, @field_messages) = $master_field_value_condition->Validate($master_field_value, $master_field_name);
            if (!$field_ok) {
                $master_field_ok = 0;
            }
        }

        if ($master_field_ok) {
            my %slave_filtered_form_data = $self->{slave_field_selector}->Filter(%form_data);
            foreach my $slave_field_name (keys %slave_filtered_form_data) {
                my $slave_field_value = $slave_filtered_form_data{$slave_field_name};
                foreach my $slave_field_value_validator (@{$self->{slave_value_validators}}) {
                    my ($field_ok, @field_messages) = $slave_field_value_validator->Validate($slave_field_value, $slave_field_name, master_field_value => $master_field_value, master_field_name => $master_field_name);
                    if (!$field_ok) {
                        $ok = 0;
                    }
                    @field_messages = map {"When field '$master_field_name' value is '$master_field_value', $_"} @field_messages;
                    push @messages, @field_messages;
                }
            }
        }
    }

    return ($ok, @messages);
}

=pod

=head3 _Applies(%args)

Checks that the selector requirements are met.

B<Note>

Internal function. Do not use from outside of this module.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments to test the selector against. This is specific for every subclass.

Required values are:

=over 2

=item C<field_name> (string)

The field name. The criteria is met if (aside from meeting the subclass' criteria) the name matches the name regex (if defined) or is equal to the expected name, in that order.

=back

=back

B<Returns>

C<0> when the field name doesn't match the criteria. C<1> when the field name matches the criteria B<and> the subclass' criteria as well.

B<See>

C<FieldSelector> for details on the field selection checking.

=cut

sub _Applies {
    my $self = shift;
    my %args = (
        @_, 
    );

    die "Legacy code. To be removed.\n";
}

1;
