=pod

=head1 NAME

FormValidator::RuleValidators::SingleField

A base class for field-based rule validators.

A subclass of C<FormValidator::AbstractContext>

=cut

package FormValidator::RuleValidators::SingleField;

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

=item C<field_selector> (hashref)

The specification (i.e., arguments dictionary) to instantiate a C<FormValidator::FieldSelector> object used to select the fields to apply this rule on.

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

=item C<field_selector> (hashref)

The specification (i.e., arguments dictionary) to instantiate a C<FormValidator::FieldSelector> object used to select the fields to apply this rule on.

=item C<value_validators> (listref of hashrefs)

The specification (i.e., arguments dictionary) to instantiate a list of C<FormValidator::AbstractFieldValueValidator> object used to validate the fields this rule applies to.

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
        field_selector => undef, 
        value_validators => undef, 
        @_, 
    );

    if (!defined $args{field_selector}) {
        die "An specification for the field selector is required.\n";
    }

    $self->SUPER::_Init(%args);

    $self->{field_selector} = FormValidator::FieldSelector::Build($args{field_selector});
    my @value_validators;
    if (defined $args{value_validators}) {
        foreach my $value_validator_spec (@{$args{value_validators}}) {
            my $value_validator = FormValidator::AbstractFieldValueValidator::Build($value_validator_spec->{class}, %{$value_validator_spec->{args}});
            push @value_validators, $value_validator;
        }
    }
    $self->{value_validators} = \@value_validators;

    return;
}

=pod

=head3 Validate(%form_data)

Validates the form data using this field-based rule.

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
    my %filtered_form_data = $self->{field_selector}->Filter(%form_data);
    foreach my $field_name (keys %filtered_form_data) {
        foreach my $field_value_validator (@{$self->{value_validators}}) {
            my ($field_ok, @field_messages) = $field_value_validator->Validate($filtered_form_data{$field_name}, $field_name);
            if (!$field_ok) {
                $ok = 0;
            }
            push @messages, @field_messages;
        }
    }

    return ($ok, @messages);
}

1;
