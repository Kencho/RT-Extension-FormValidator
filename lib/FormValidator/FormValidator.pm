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

Call this from a class/module context, not from an existing instance. I.e., C<FormValidator::FormValidator-E<gt>new()>

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

1;
