#!/usr/bin/env perl
# PODNAME: an example RDAP Server using Net::RDAP::Server::EPPBackend.
use Net::RDAP::Server::EPPBackend;
use Pod::Usage;
use Getopt::Long;
use YAML::XS;
use strict;

my ($cfile, $help);
pod2usage(1) unless (GetOptions('help' => \$help, 'config=s' => \$cfile));
pod2usage(0) if ($help);

$cfile ||= shift(@ARGV);
pod2usage(1) unless (-r $cfile);

my $server = Net::RDAP::Server::EPPBackend->new();

$server->set_backend(%{YAML::XS::LoadFile($cfile)});

$server->run;

=pod

=head1 SYNOPSIS

    rdap-epp.pl [--help|--config=CONFIG_FILE|CONFIG_FILE]

=head1 OPTIONS

=over

=item * C<--help> - display this help.

=item * C<--config=CONFIG_FILE> - specify config file. You can also just
specify the file without the C<--config=> part.

=back

C<CONFIG_FILE> is a YAML file containing arguments to the
L<Net::EPP::Simple> constructor (at minimum C<host>, C<user>, C<pass>, etc).

=cut
