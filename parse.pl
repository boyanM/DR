#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use JSON;
use Time::HiRes qw(gettimeofday);       
#use WWW::Curl;


sub get_clients {
	my $clients_ref = $_[0];
	my $timestamp = gettimeofday();		# should be in nanoseconds
	#open my $dump, '-|', 'iw dev wlan1 station dump';
	open my $dump, '<', "/home/boyan/Desktop/test.txt" or die "Could not open $!";
	my $mac = '';
	while (<$dump>) {
		my $line = $_;
		if ($line =~ /Station/) {
			$mac = '';
			my @client = split /\s+/, $line;
			$mac = $client[1];
			push(@{$clients_ref->{$mac}}, $timestamp);
		}
		if ($line =~ /signal:/) {
			$line =~ s/[\[\]]//g;
			my @signal = split /\s+/, $line;
			push(@{$clients_ref->{$mac}}, $signal[2]);
			push(@{$clients_ref->{$mac}}, $signal[3]);
			push(@{$clients_ref->{$mac}}, $signal[4]);
		}	
		if ($line =~ /signal avg:/) {
			$line =~ s/[\[\]]//g;
			my @signal = split /\s+/, $line;
			push(@{$clients_ref->{$mac}}, $signal[3]);
			push(@{$clients_ref->{$mac}}, $signal[4]);
			push(@{$clients_ref->{$mac}}, $signal[5]);	
		}
		# all other lines should be skipped
	}
	close $dump;
}

# %clients
# [0] - timestamp
# [1] - signal strength
# [2] - signal minimum
# [3] - signal maximum
# [4] - signal avg strength
# [5] - signal avg minimum
# [6] - signal avg maximum

my %clients = ();
while(1) {
	get_clients(\%clients);
	# %clients should be written in JSON format in /www/clients.json on the APs
	my $json = encode_json \%clients;
		print "$json\n";
	# my curl -d "@json.json" -X POST http://localhost:3000/json


	while (my ($key, $val) =  each(%clients)) {
		#my @arr = @{$val};
		#print $key, ' ', $arr[0], ' ', $arr[1], "\n";
		print $key, ' ', $clients{$key}[0], ' ', $clients{$key}[1], "\n";
		
	}
	sleep 2;
}
