=pod

=head1 NAME

FormValidator::FieldSelector

A class that matches fields by their name.

=cut

package FormValidator::FieldSelector;

use strict;
use warnings;

=pod

=head2 Methods

=cut

=pod

=head3 I<static> Build($spec_ref)

Creates a new C<FieldSelector> using the given parameters.

B<Note>

This is an static method. Call it using the class itself, not an instance.

B<Parameters>

=over 1

=item C<$spec_ref> (hashref)

A reference to a hashmap containing the arguments to use in the constructor.

=back

=cut

sub Build {
    my $spec_ref = shift;

    my $field_selector = __PACKAGE__->new(%{$spec_ref});

    return $field_selector;
}

=pod

=head3 new()

The constructor.

=cut

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->_Init(@_);
    return $self;
}

=pod

=head3 Init(%args)

B<Parameters>

=over 1

=item C<%args>

A hashmap of arguments for the condition.

Possibly used values are:

=over 2

=item C<field_name_regex> (regex string)

If defined, will set the regex used against the field name to meet the criteria.

=item C<field_name> (string)

If defined, will set the expected field name to meet the criteria (if the C<field_name_regex> doesn't match first).

=back

=back

=cut

sub _Init {
    my $self = shift;
    my %args = (
        field_name_regex => undef, 
        field_name => undef, 
        @_, 
    );

    $self->SetFieldNameRegex($args{field_name_regex});
    $self->SetFieldName($args{field_name});

    return;
}

=pod

=head3 FieldNameRegex()

Gets the field name regex of this selector.

B<Returns>

A string with the current field name regex.

=cut

sub FieldNameRegex {
    my $self = shift;

    return $self->{field_name_regex};
}

=pod

=head3 SetFieldNameRegex($field_name_regex)

Sets the field name regex of this selector.

B<Parameters>

=over 1

=item C<$field_name_regex> (string)

A string with the new field name regex.

=back

=cut

sub SetFieldNameRegex {
    my $self = shift;
    my $field_name_regex = shift;

    $self->{field_name_regex} = $field_name_regex;

    return;
}

=pod

=head3 FieldName()

Gets the field name of this selector.

B<Returns>

A string with the current field name.

=cut

sub FieldName {
    my $self = shift;

    return $self->{field_name};
}

=pod

=head3 SetFieldName($field_name)

Sets the field name of this selector.

B<Parameters>

=over 1

=item C<$field_name> (string)

A string with the new field name.

=back

=cut

sub SetFieldName {
    my $self = shift;
    my $field_name = shift;

    $self->{field_name} = $field_name;

    return;
}

=pod

=head3 Matches($field_name)

Tests a field's name against this selector.

B<Parameters>

=over 1

=item C<$field_name> (string)

The field's name to test.

=back

B<Returns>

C<1> if C<$field_name> matches the selector's rules; C<0> otherwise.

=cut

sub Matches {
    my $self = shift;
    my $field_name = shift;

    if (defined $self->FieldNameRegex()) {
        return $self->_MatchesNameRegex($field_name);
    }
    if (defined $self->FieldName()) {
        return $self->_MatchesName($field_name);
    }

    return 0;
}

=pod

=head3 _MatchesNameRegex($field_name)

Tests whether the field name matches this selector's field name regex.

B<Parameters>

=over 1

=item C<$field_name>

The field name to test against this selector.

=back

B<Returns>

C<1> if the name matches the selector's field name regex; C<0> otherwise.

=cut

sub _MatchesNameRegex {
    my $self = shift;
    my $field_name = shift;

    my $regex = $self->FieldNameRegex();
    if ($field_name =~ m{$regex}) {
        return 1;
    }
    else {
        return 0;
    }

    return 0;
}

=pod

=head3 _MatchesName($field_name)

Tests whether the field name matches this selector's field name.

B<Parameters>

=over 1

=item C<$field_name>

The field name to test against this selector.

=back

B<Returns>

C<1> if the name matches the selector's field name; C<0> otherwise.

=cut

sub _MatchesName {
    my $self = shift;
    my $field_name = shift;

    if ($field_name eq $self->FieldName()) {
        return 1;
    }
    else {
        return 0;
    }

    return 0;
}

1;
