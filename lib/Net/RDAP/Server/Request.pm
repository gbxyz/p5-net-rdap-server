package Net::RDAP::Server::Request;
# ABSTRACT: An RDAP request object.
use base qw(HTTP::Request);

=pod

=head1 DESCRIPTION

L<Net::RDAP::Server::Request> represents an RDAP query.
L<Net::RDAP::Server::Response> extends L<HTTP::Response>.

=cut


=pod

=head1 ADDITIONAL METHODS

=head2 from_cgi($cgi)

This method constructs a L<Net::RDAP::Server::Request> object from a L<CGI>
object (L<Net::RDAP::Server> is based on L<HTTP::Server::Simple::CGI> which uses
the CGI API).

=cut

sub from_cgi {
    my ($package, $cgi) = @_;

    my $url = URI->new(sprintf(
        '%s://%s:%s%s',
        $cgi->protocol,
        $cgi->virtual_host,
        $cgi->server_port,
        $cgi->request_uri,
    ))->canonical;

    my $request = $package->new($cgi->request_method, $url);

    foreach my $name (map { lc } $cgi->http) {
        my $value = $cgi->http($name);
        $name =~ s/^http_//i;
        $name =~ s/_/-/g;
        $request->header($name => $value);
    }

    $request->{_cgi} = $cgi;

    return $request;
}

=pod

=head2 cgi()

This returns the L<CGI> object from which this object was constructed.

=cut

sub cgi { shift->{_cgi} }

=pod

=head2 type()

This returns a string containing the RDAP query type (e.g. C<domain>, C<ip>,
etc).

=cut

sub type {
    my $self = shift;

    return [ grep { length > 0 } $self->uri->path_segments ]->[0];
}

=pod

=head2 object()

This returns a string containing the requested object. This value is irrelevant
for help queries and searches.

=cut

sub object {
    my $self = shift;

    my @segments = grep { length > 0 } $self->uri->path_segments;

    shift(@segments);

    return join('/', @segments);
}

1;
