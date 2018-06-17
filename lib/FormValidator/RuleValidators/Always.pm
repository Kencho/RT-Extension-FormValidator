=pod

=head1 NAME

FormValidator::RuleValidators::Always

A simple rule validator class that always passes.

A subclass of C<FormValidator::AbstractContext>

=cut

package FormValidator::RuleValidators::Always;

use strict;
use warnings;

use parent 'FormValidator::AbstractRuleValidator';

=pod

=head2 Methods

=cut

=pod

=head3 new()

The constructor.

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments for the rule validator. No values are expected here, but may be used by a superclass.

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

=head3 Validate(%form_data)

Validates the form data using this "always pass" rule.

B<See>

C<FormValidator::AbstractRuleValidator::Validate> for additional details on this function.

=cut

sub Validate {
    return (1);
}

=pod

=head3 Applies(%args)

Checks that the selector requirements are met.

B<Returns>

Always C<1> (i.e., always applies).

=cut

sub Applies {
    my $self = shift;
    my %args = (
        @_, 
    );

    return 1;
}

1;
