=pod

=head1 NAME

FormValidator::FieldValueValidators::IsNumeric

A field value validator class that ensures a field value is numeric.

A subclass of C<FormValidator::AbstractFieldValueValidator>

=cut

package FormValidator::FieldValueValidators::IsNumeric;

use strict;
use warnings;

use parent 'FormValidator::AbstractFieldValueValidator';

=pod

=head2 Methods

=cut

=pod

=head3 new()

The constructor.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments for the field value validator.

Optional values are:

=over 2

=item C<integer_only> (boolean)

If set to true (C<1>) only integer numbers will be considered valid. Set to false (C<0>, default) to allow both integers and decimals as valid values.

=item C<positive_only> (boolean)

If set to true (C<1>) only positive numbers will be considered valid. Set to false (C<0>, default) to allow both positives and negatives as valid values.

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

sub _Init {
    my $self = shift;
    my %args = (
        integer_only => 0, 
        positive_only => 0, 
        @_, 
    );

    $self->SUPER::_Init(%args);

    $self->SetIntegerOnly($args{integer_only});
    $self->SetPositiveOnly($args{positive_only});

    return;
}

=pod

=head3 IntegerOnly()

Gets whether or not decimal values will be valid or not.

B<Returns>

True (C<1>) if only integer values will be valid. False (C<0>) otherwise.

=cut

sub IntegerOnly {
    my $self = shift;

    return $self->{integer_only};
}

=pod

=head3 SetIntegerOnly($integer_only)

Sets whether or not decimal values will be valid or not.

B<Parameters>

=over 1

=item C<$integer_only> (boolean)

True (C<1>) if only integer values should be valid. False (C<0>) otherwise.

=back

=cut

sub SetIntegerOnly {
    my $self = shift;
    my $integer_only = shift;

    $self->{integer_only} = $integer_only ? 1 : 0;

    return;
}

=pod

=head3 PositiveOnly()

Gets whether or not negative values will be valid or not.

B<Returns>

True (C<1>) if only positive values will be valid. False (C<0>) otherwise.

=cut

sub PositiveOnly {
    my $self = shift;

    return $self->{positive_only};
}

=pod

=head3 SetPositiveOnly($positive_only)

Sets whether or not negative values will be valid or not.

B<Parameters>

=over 1

=item C<$positive_only> (boolean)

True (C<1>) if only positive values should be valid. False (C<0>) otherwise.

=back

=cut

sub SetPositiveOnly {
    my $self = shift;
    my $positive_only = shift;

    $self->{positive_only} = $positive_only ? 1 : 0;

    return;
}

=pod

=head3 Validate($field_value, $field_name, %additional_data)

Validates the field value using this validator.

B<Parameters>

=over 1

=item C<$field_value> (scalar)

The value of the field as a scalar.

=item C<$field_name> (string)

The name of the field being validated.

=item C<%additional_data> (hashmap)

Any additional data a rule validator may pass to this field value validator.

=back

B<Returns>

A pair of values:

=over 1

=item C<$ok> (boolean)

Whether the validation passed (C<1>) or not (C<0>).

=item C<@messages> (list of strings)

A list of reasons why, in case the validation didn't pass.

=back

=cut

sub Validate {
    my $self = shift;
    my $field_value = shift;
    my $field_name = shift;
    my %args = (
        @_, 
    );

    if (!defined $field_value) {
        return (1);
    }

    $field_value =~ s/^\s+|\s+$//xms;

    if ($field_value eq q{}) {
        return (1);
    }

    my $sign_regex;
    my $sign_error_indicator = q{};
    if ($self->PositiveOnly()) {
        $sign_regex = "[+]?";
        $sign_error_indicator = " positive and";
    }
    else {
        $sign_regex = "[+-]?";
    }

    my $number_regex;
    my $number_error_indicator;
    if ($self->IntegerOnly()) {
        $number_regex = "$sign_regex\\d+";
        $number_error_indicator = "$sign_error_indicator integer";
    }
    else {
        $number_regex = "$sign_regex(?:\\d+\\.?|\\d*\\.\\d+)(?:[eE][+-]?\\d+)?";
        $number_error_indicator = "$sign_error_indicator decimal";
    }

    if ($field_value !~ /^$number_regex$/xmsi) {
        return (0, "The '$field_name' field value must be$number_error_indicator.");
    }

    return (1);
}

1;
