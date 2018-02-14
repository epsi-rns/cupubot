#!/usr/bin/perl

use warnings;                   # Good practice
use strict;                     # Good practice

# require to install via CPAN
# $ cpan install LWP::Protocol::https
# $ cpan install JSON

use LWP::Simple;                # From CPAN
use JSON qw( decode_json );     # From CPAN

use Data::Dumper;               # Perl core module

# ----- ----- -----
# config

if (! -f "$ENV{HOME}/.config/cupubot/config.pm") { 
    print "Config not found!\n";
    exit 1
} else {
	use lib "$ENV{HOME}/.config/cupubot";
    use config;
}

my $tele_url = "https://api.telegram.org/bot${token}";

# ----- ----- -----
# http

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;

my $response = $ua->get("${tele_url}/getUpdates");

my $content;

if ($response->is_success) {
    $content = $response->decoded_content;  # or whatever
}
 else {
    die $response->status_line;
}

# ----- ----- -----
# json

# Decode the entire JSON
my $decoded_json = decode_json( $content );

# result node
my $result = $decoded_json->{'result'};
my $count_update = scalar(@$result);

print $count_update;
print "\n";

# ----- ----- -----
# main

foreach my $update (@$result) {	
	# print Dumper $update;
    # print "\n";
    
    my $update_id = $update->{'update_id'};
    print "$update_id\n";
}
