=pod

=head1 NAME

FormValidator::FieldValueValidators::NonEmpty

A field value validator class that ensures a field has a value.

A subclass of C<FormValidator::AbstractFieldValueValidator>

=cut

package FormValidator::FieldValueValidators::NonEmpty;

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

=item C<trim_spaces> (boolean)

If set to true (C<1>, default) the spaces will be trimmed and considered an empty field. Set to false (C<0>) to allow spaces as a valid value.

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
        trim_spaces => 1, 
        @_, 
    );

    $self->SUPER::_Init(%args);

    $self->SetTrimSpaces($args{trim_spaces});

    return;
}

=pod

=head3 TrimSpaces()

Gets whether or not spaces in the value will be trimmed or not.

B<Returns>

True (C<1>) if the spaces will be trimmed. False (C<0>) otherwise.

=cut

sub TrimSpaces {
    my $self = shift;

    return $self->{trim_spaces};
}

=pod

=head3 SetTrimSpaces($trim_spaces)

Gets whether or not spaces in the value will be trimmed or not.

B<Parameters>

=over 1

=item C<$trim_spaces> (boolean)

True (C<1>) if the spaces should be trimmed. False (C<0>) otherwise.

=back

=cut

sub SetTrimSpaces {
    my $self = shift;
    my $trim_spaces = shift;

    $self->{trim_spaces} = $trim_spaces ? 1 : 0;

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

    my $error_message = "Field '$field_name' cannot be empty.";
    if (!$self->TrimSpaces()) {
        $error_message = "$error_message Spaces-only values are allowed.";
    }

    if (!defined $field_value) {
        return (0, $error_message);
    }

    if ($self->TrimSpaces()) {
        $field_value =~ s/^\s+|\s+$//xms;
    }

    if ($field_value eq q{}) {
        return (0, $error_message);
    }
    else {
        return (1);
    }

    return (1);
}

1;
