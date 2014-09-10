# valid.pl -- check for valid stuff
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990617/990619

use strict; 

sub valid_email {
	local $_ = shift; 

	y/@/@/ != 1	and return 0; 
	/\.\./		and return 0; 
	/@\./ || /\.@/	and return 0; 
	/^\./ || /\.$/	and return 0; 
	# next line from Copyright 1995-1997 Matthew M. Wright, formmail
	#/^.+@\[?(\w|[-.])+\.[a-zA-Z]{2,3}|[0-9]{1,3}\]?$/
	/^.+@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3}|[0-9]{1,3})(\]?)$/
			or return 0; 
	return 1; 
}

sub valid_url {
	local $_ = shift; 
  
	/^mailto:.*@\S+\./		and return 1; 
	/^news:/			and return 1; 
	/^(f|ht)tp:\/\/\S+\.\S+/	and return 1; 

	return 0; 
}

sub valid_ip {
	local $_ = shift; 
	my @a = split /\./, $_; 
	@a != 4				and return 0; 
	$_ = $a[0]; /^\d+$/		or return 0; 
	$_ = $a[1]; /^\d+$/		or return 0; 
	$_ = $a[2]; /^\d+$/		or return 0; 
	$_ = $a[3]; /^\d+$/		or return 0; 
	return 1; 
}

sub valid_integer {
	local $_ = shift; 
	return /^\d+$/; 
}

# validate what perl thinks to be numbers... 
sub valid_perl_number {
	local $_ = shift; 

	$_ != 0 and return 1; 
	my $a = $_; $a += 1; 
	my $b = $_; $b .= ""; $b++; 
	return $a == $b;	# use magic autoincrement
}

# validate numbers
sub valid_number {
	local $_ = shift; 
	s/^[-+]//; 
	s/^[0-9]*\.[0-9]+// and goto expon; 	# .000
	s/^[0-9]+// and goto expon; 		# 000
	return 0; 
expon:
	$_ eq "" and return 1; 
	s/^[eE]// or return 0; 
	s/^[-+]//; 
	s/[0-9]+//;
	return $_ eq ""; 
}

# a single re to validate a number
sub valid_number_re {
	local $_ = shift; 
	return /^[-+]?(\d*\.\d+|\d+)([eE][-+]?\d+)?$/; 
}

# args: yy,mm,dd
{my @m = (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31); 
sub valid_date {
	my ($yy, $mm, $dd) = @_; 
	$mm < 1 and return 0; 
	$mm > 12 and return 0; 
	$dd < 1 and return 0; 
	$dd > $m[$mm-1] and return 0; 
	$mm == 2 					# feb
	  and !($yy%400==0 || ($yy%4==0 && $yy%100!=0)) # on a non leap year
	  and $dd == 29 				# with 29 days?
	  and return 0; 

	return 1; 
}}

### test 
sub t { 
	my $fnme = shift; 
	my $f = shift; 
	my $expected = shift; 
	my $args = join ",", @_;
	my $r = &{$f}(@_); 
	##print "$fnme($args): ", $r ? "ok\n" : "fail\n";
	if ($expected != $r) {
		print "$fnme($args) FAILED (ret $r vs $expected expected)\n"; 
	}
}

t "valid_email", \&valid_email, 1, "cgd\@teleweb.pt"; 
t "valid_email", \&valid_email, 0, "\@asd\@teleweb.pt"; 
t "valid_url", \&valid_url, 1, "ftp://devlis01i.teleweb.pt/foo/bar";
t "valid_url", \&valid_url, 0, "blaasdf";
t "valid_ip", \&valid_ip, 1, "192.168.168.12";
t "valid_ip", \&valid_ip, 0, "192.168.12";
t "valid_ip", \&valid_ip, 0, "192.168.d.12";
t "valid_number", \&valid_number, 1, "0"; 
t "valid_number", \&valid_number, 1, "01"; 
t "valid_number", \&valid_number, 1, "1e3"; 
t "valid_number", \&valid_number, 1, ".01"; 
t "valid_number", \&valid_number, 1, "123"; 
t "valid_number", \&valid_number, 0, "aa"; 
t "valid_number", \&valid_number, 0, "11aa"; 
t "valid_number", \&valid_number, 0, "aa22"; 
t "valid_number", \&valid_number, 1, "2.01"; 
t "valid_number", \&valid_number, 1, ".01e-21"; 
t "valid_number", \&valid_number, 1, "1.01e21"; 
t "valid_number", \&valid_number, 1, "+11.01e+21"; 
t "valid_number", \&valid_number, 1, "-11.01e+21"; 
t "valid_number", \&valid_number, 1, "000.00"; 
t "valid_number", \&valid_number, 1, rand(); 
t "valid_date", \&valid_date, 1, 2000, 2, 29; 
t "valid_date", \&valid_date, 1, 2000, 2, 28; 
t "valid_date", \&valid_date, 0, 2000, 2, 30; 
t "valid_date", \&valid_date, 0, 1900, 2, 29; 
t "valid_date", \&valid_date, 1, 1900, 2, 28; 
t "valid_date", \&valid_date, 0, 1900, 2, 30; 
t "valid_date", \&valid_date, 1, 1904, 2, 29; 
t "valid_date", \&valid_date, 1, 1904, 2, 28; 
t "valid_date", \&valid_date, 0, 1904, 2, 30; 
t "valid_date", \&valid_date, 0, 1955, 2, 29; 
t "valid_date", \&valid_date, 1, 1955, 2, 28; 
t "valid_date", \&valid_date, 0, 1955, 2, 30; 
