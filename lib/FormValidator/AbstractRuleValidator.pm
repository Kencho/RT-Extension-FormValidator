=pod

=head1 NAME

FormValidator::AbstractRuleValidator

The base class for every rule validator.

=cut

package FormValidator::AbstractRuleValidator;

use strict;
use warnings;

use Module::Load;

=pod

=head2 Methods

=cut

=pod

=head3 I<static> Build($class, %args)

Creates a new rule validator using reflection.

B<Note>

This is an static method. Call it using the class itself, not an instance (i.e., C<my $rule_validator = FormValidator::AbstractRuleValidator::Build('My::RuleValidator::Class', {field =E<gt> 'my-field-id'});>)

B<Parameters>

=over 1

=item C<$class>

The fully qualified name of the class to instantiate.

=item C<%args>

The arguments to pass to the concrete rule validator class constructor.

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

A hashmap of arguments for the rule validator. This is specific for every subclass.

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

=head3 Validate(%form_data)

Validates the form data using this rule.

B<Note>

This is an abstract method and must be implemented by its subclasses.

B<Parameters>

=over 1

=item C<%form_data> (hashmap)

The whole form data as a hashmap.

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

=pod

=head3 Applies(%args)

Determines whether the rule applies to a certain set of arguments or not.

B<Note>

This is an abstract method and must be implemented by its subclasses.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments that are expected to meet the selection criteria.

=back

B<Returns>

C<1> if the arguments meet the selection criteria, C<0> if they don't.

=cut

sub Applies {
    die __PACKAGE__ . "::Applies is an abstract method and it's expected to be implemented by the subclass being used.\n";
}

1;
