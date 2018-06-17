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

Possibly used values are:

=over 2

=item C<field_name_regex> (regex string)

If defined, will set the regex used against the field name to meet the criteria.

=item C<field_name> (string)

If defined, will set the expected field name to meet the criteria (if the C<field_name_regex> doesn't match first).

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

Possibly used values are:

=over 2

=item C<field_name_regex> (regex string)

If defined, will set the regex used against the field name to meet the criteria.

=item C<field_name> (string)

If defined, will set the expected field name to meet the criteria (if the C<field_name_regex> doesn't match first).

=back

At least one of C<field_name_regex> or C<field_name> is required.

=back

B<See also>

=over 1

=item C<FormValidator::AbstractContext> for details on other arguments.

=back

=cut

sub _Init {
    my $self = shift;
    my %args = (
        field_name_regex => undef, 
        field_name => undef, 
        @_, 
    );

    if (!defined $args{field_name_regex} && !defined $args{field_name}) {
        die "At least a value for field_name_regex or field_name is required.\n";
    }

    $self->SUPER::_Init(%args);

    $self->{field_selector} = FormValidator::FieldSelector->new(%args);

    return;
}

=pod

=head3 Validate(%form_data)

Validates the form data using this field-based rule.

B<Note>

This is an abstract method and must be implemented by its subclasses.

B<See>

C<FormValidator::AbstractRuleValidator::Validate> for additional details on this function.

=cut

sub Validate {
    die __PACKAGE__ . "::Validate is an abstract method and it's expected to be implemented by the subclass being used.\n";
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

    my $field_name = $args{field_name};

    return $self->{field_selector}->Matches($field_name);
}

1;
