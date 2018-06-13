=pod

=head1 NAME

FormValidator::Conditions::Always

A simple condition class that always passes.

A subclass of C<FormValidator::AbstractContext>

=cut

package FormValidator::Conditions::Always;

use strict;
use warnings;

use parent 'FormValidator::AbstractCondition';

=pod

=head2 Methods

=cut

=pod

=head3 new()

The constructor.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments for the condition. No values are expected here, but may be used by a superclass.

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
        @_, 
    );

    $self->SUPER::_Init(%args);

    return;
}

=pod

=head3 _Check(%args)

Checks that the condition requirements are met.

B<Returns>

Always C<1> (although it will be negated if C<Inverted>, i.e., no input meets the criteria).

=cut

sub _Check {
    my $self = shift;
    my %args = (
        @_, 
    );

    return 1;
}

1;
