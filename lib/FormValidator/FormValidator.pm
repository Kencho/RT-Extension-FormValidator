=pod

=head1 NAME

FormValidator::FormValidator

The core validation class.

=cut

package FormValidator::FormValidator;

use strict;
use warnings;

=pod

=head2 Methods

=cut

=pod

=head3 new()

The class constructor.

B<Note>

Call this from a class/module context, not from an existing instance. I.e., C<FormValidator::FormValidator-E<gt>new();> is ok, C<$my_form_validator-E<gt>new();> is not.

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

    return;
}

=pod

=head3 Validate($action, $queue_id, $form_data)

Validates the form data in a given context (action and queue).

B<Parameters>

=over 1

=item C<$action> (string)

The form action (e.g., C<'Ticket/Create'>, C<'Ticket/Update'>).

=item C<$queue_id> (integer|string)

The queue identifier number or name.

=item C<$form_data> (hashref)

The hash reference with the form data.

=back

B<Returns>

A list of values:

=over 1

=item C<$ok>

C<1> (true) on success, C<0> (false) on error.

=back

=cut

sub Validate {
    my $self = shift;
    my $action = shift;
    my $queue_id = shift;
    my $form_data = shift;

    my $result = 1;

    # TODO: Implement the actual validation logic.

    return $result;
}

1;
