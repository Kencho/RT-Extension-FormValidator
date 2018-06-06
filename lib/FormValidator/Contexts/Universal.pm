=pod

=head1 NAME

FormValidator::Contexts::Universal

A simple context class for the universal context.

A subclass of C<FormValidator::AbstractContext>

=cut

package FormValidator::Contexts::Universal;

use strict;
use warnings;

use parent 'FormValidator::AbstractContext';

=pod

=head2 Methods

=cut

=pod

=head3 new()

The constructor.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments for the context. No values are expected here, but may be used by a superclass.

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

Checks that the context queue requirements are met.

B<Returns>

Always C<1> (although it will be negated if C<Inverted>, i.e., no context meets the criteria).

=cut

sub _Check {
    my $self = shift;
    my %args = (
        @_, 
    );

    return 1;
}

1;
