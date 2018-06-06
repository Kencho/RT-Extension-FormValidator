=pod

=head1 NAME

FormValidator::Contexts::Queue

A simple context class for an specific queue.

A subclass of C<FormValidator::AbstractContext>

=cut

package FormValidator::Contexts::Queue;

use strict;
use warnings;

use parent 'FormValidator::AbstractContext';

=pod

=head2 Methods

=cut

=pod

=head3 new(%args)

The constructor.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments for the context.

Expected values are: 

=over 2

=item C<queue_id> (integer|string)

The queue id number or name for the queue that this context represents. Defaults to C<undef>

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
        @_, 
    );

    $self->SUPER::_Init(%args);

    if (!defined($args{queue_id})) {
        die "A defined queue id was expected in the parameter queue_id.\n";
    }

    $self->{queue_id} = $args{queue_id};

    return;
}

=pod

=head3 _Check(%args)

Checks that the context queue requirements are met.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments that are expected to meet the context criteria.

Expected keys are at least: 

=over 2

=item C<queue_id>

The queue id number or name.

=back

=back

B<Returns>

C<1> if the C<queue_id> argument meets the context queue criteria, C<0> if it doesn't.

=cut

sub _Check {
    my $self = shift;
    my %args = (
        @_, 
    );

    if (!defined($args{queue_id})) {
        die __PACKAGE__ . "::Check: A queue_id argument was expected.\n";
    }

    if ($self->{queue_id} eq $args{queue_id}) {
        return 1;
    }

    return 0;
}

1;
