=pod

=head1 NAME

FormValidator::AbstractFieldValueValidator

A base class for field value validators.

=cut

package FormValidator::AbstractFieldValueValidator;

use strict;
use warnings;

use Module::Load;

=pod

=head2 Methods

=cut

=pod

=head3 I<static> Build($class, %args)

Creates a new field value validator using reflection.

B<Note>

This is an static method. Call it using the class itself, not an instance (i.e., C<my $field_value_validator = FormValidator::AbstractFieldValueValidator::Build('My::FieldValueValidator::Class', ...);>)

B<Parameters>

=over 1

=item C<$class>

The fully qualified name of the class to instantiate.

=item C<%args>

The arguments to pass to the concrete field value validator class constructor.

=back

=cut

sub Build {
    my $class = shift;
    my %args = (@_);

    load($class);

    my $rule_validator = $class->new(%args);
    if (!$rule_validator->isa(__PACKAGE__)) {
        die "The given class $class isn't a subclass of " . __PACKAGE__ . "\n";
    }

    return $rule_validator;
}

=pod

=head3 new(%args)

The abstract constructor.

B<Note>

This ensures that this class won't be constructed itself. Instead, users must instantiate its subclasses directly.

=cut

sub new {
    die __PACKAGE__ . " is an abstract class and cannot be instantiated directly.\n";
}

=pod

=head3 _Init(%args)

Initialization method.

B<Note>

Don't override, as it initializes internal attributes. Instead, call it from the subclasses initializers using C<$self-E<gt>SUPER::_Init(%args)>

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments for the field value validator. This is specific for every subclass.

=back

=cut

sub _Init {
    my $self = shift;
    my %args = (
        @_,
    );

    return;
}

=pod

=head3 Validate($field_value, $field_name, %additional_data)

Validates the field value using this validator.

B<Note>

This is an abstract method and must be implemented by its subclasses.

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
    die __PACKAGE__ . "::Validate is an abstract method and it's expected to be implemented by the subclass being used.\n";
}

1;
