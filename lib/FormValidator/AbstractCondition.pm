=pod

=head1 NAME

FormValidator::AbstractCondition

The base class for every condition.

=cut

package FormValidator::AbstractCondition;

use strict;
use warnings;

use Module::Load;

=pod

=head2 Methods

=cut

=pod

=head3 I<static> Build($class, %args)

Creates a new condition using reflection.

B<Note>

This is an static method. Call it using the class itself, not an instance (i.e., C<my $condition = FormValidator::AbstractCondition::Build('My::Condition::Class', {field =E<gt> 'my-field-id'});>)

B<Parameters>

=over 1

=item C<$class>

The fully qualified name of the class to instantiate.

=item C<%args>

The arguments to pass to the concrete condition class constructor.

=back

=cut

sub Build {
    my $class = shift;
    my %args = (@_);

    load($class);

    my $condition = $class->new(%args);
    if (!$condition->isa(__PACKAGE__)) {
        die "The given class $class isn't a subclass of " . __PACKAGE__ . "\n";
    }

    return $condition;
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

A hashmap of arguments for the condition. This is specific for every subclass.

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

=head3 _Check(%args)

The verification method.

B<Note>

This is an abstract method and must be implemented by its subclasses.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments that are expected to meet the context criteria.

=back

B<Returns>

C<1> if the arguments meet the condition criteria, C<0> if they don't.

=cut

sub Check {
    die __PACKAGE__ . "::Check is an abstract method and it's expected to be implemented by the subclass being used.\n";
}

1;
