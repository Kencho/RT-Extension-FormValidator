=pod

=head1 NAME

FormValidator::AbstractContext

The base class for every context.

=cut

package FormValidator::AbstractContext;

use strict;
use warnings;

=pod

=head2 Methods

=cut

=pod

=head3 I<static> Build($class, %args)

Creates a new context using reflection.

B<Note>

This is an static method. Call it using the class itself, not an instance (i.e., C<my $context = FormValidator::AbstractContext::Build('My::Context::Class', {queue_id =E<gt> 345});>)

B<Parameters>

=over 1

=item C<$class>

The fully qualified name of the class to instantiate.

=item C<%args>

The arguments to pass to the concrete context class constructor.

=back

=cut

sub Build {
    my $class = shift;
    my %args = (@_);

    my $context = $class->new(%args);
    if (!$context->isa(__PACKAGE__)) {
        die "The given class $class isn't a subclass of " . __PACKAGE__ . "\n";
    }

    return $context;
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

A hashmap of arguments for the context. This is specific for every subclass.

Possibly used values are:

=over 2

=item C<inverted> (boolean)

If defined, will set the initial state of the C<Inverted> flag.

=back

=back

=cut

sub _Init {
    my $self = shift;
    my %args = (
        inverted => 0, 
        @_,
    );

    $self->SetInverted($args{inverted});

    return;
}

=pod

=head3 Check(%args)

Checks that the context requirements are met.

B<Note>

Don't override this method, as it does some common operations (like inverting the result when applicable). Override C<_Init> instead.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments that are expected to meet the context criteria.

Expected keys are: 

=over 2

=item C<action>

The action this validation is called against (e.g., C<Item/Create>, C<Item/Update>).

=item C<queue_id>

The queue id number or name.

=back

=back

B<Returns>

C<1> if the arguments meet the context criteria, C<0> if they don't.

=cut

sub Check {
    my $self = shift;

    my $result = $self->_Check(@_);
    if ($self->Inverted()) {
        if ($result) {
            $result = 0;
        }
        else {
            $result = 1;
        }
    }

    return $result;
}

=pod

=head3 Check(%args)

The actual verification method, called internally by C<Init>.

B<Note>

This is an abstract method and must be implemented by its subclasses.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments that are expected to meet the context criteria.

Expected keys are: 

=over 2

=item C<action>

The action this validation is called against (e.g., C<Item/Create>, C<Item/Update>).

=item C<queue_id>

The queue id number or name.

=back

=back

B<Returns>

C<1> if the arguments meet the context criteria, C<0> if they don't.

=cut

sub _Check {
    die __PACKAGE__ . "::_Check is an abstract method and it's expected to be implemented by the subclass being used.\n";
}

=pod

=head3 Inverted()

Gets whether this context inverts its test (i.e., true when the criteria B<isn't> met)

B<Returns>

C<1> when the test will return true if the criteria B<isn't> met, C<0> for the usual behaviour.

=cut

sub Inverted {
    my $self = shift;

    return $self->{inverted};
}

=pod

=head3 SetInverted($inverted)

Sets whether this context inverts its test (i.e., true when the criteria B<isn't> met)

B<Parameters>

=over 1

=item C<$inverted>

C<1> when the test will return true if the criteria B<isn't> met, C<0> for the usual behaviour.

=back

=cut

sub SetInverted {
    my $self = shift;
    my $inverted = shift;

    if ($inverted) {
        $self->{inverted} = 1;
    }
    else {
        $self->{inverted} = 0;
    }

    return;
}

1;