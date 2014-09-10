#! /usr/bin/perl

# cgi.pl -- parse cgi form data
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990217

use strict; 

# parse cgi form data.  supports both post and get method.  no args. 
# returns a reference to an hash containing data: VAR=VALUE
# 
sub cgi_parse {
	my $data; 
	my %h; 

	my $meth;
	my @meth = (uc $ENV{"REQUEST_METHOD"}, "GET", "POST"); 

	SW: while ($data eq "") {
		defined($meth = shift @meth) or return 0; 

		$meth eq "GET" and do {
			$data = $ENV{'QUERY_STRING'};
			next SW; 
		}; 
		$meth eq "POST" and do {
			$data = ""; 
			read STDIN, $data, $ENV{'CONTENT_LENGTH'}; 
			next SW; 
		};
	}

	my @v = split /\&/, $data; 
	for my $s (@v) {
		my @vv = split /=/, $s, 2; 
		for my $x (@vv) {
			$x =~ s/\+/ /g; 
			$x =~ s/%(..)/chr(hex($1))/ge;
		}
		##print $vv[0], " = ", $vv[1], "\n"; 
		$h{$vv[0]} = $vv[1]; 
	}
	return \%h; 
}

#my %cgi = %{ &cgi_parse() }; 
#for my $k (keys %cgi) {
#	print "$k = \"$cgi{$k}\"\n"; 
#}
