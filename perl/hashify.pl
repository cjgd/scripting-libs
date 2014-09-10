# hashify.pl -- working with hash files, with text source
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 991101

use strict; 
use DB_File;

# read key/value from SOURCE text file, and produce an 
# equivalent DEST db file, overwriting if it exists
#
sub hashify { 				# $source, $dest
	my $source = shift; 
	my $dest = shift; 
	unlink $dest; 
	local ($_,$.,*FF); 
	open FF,">$dest" and print FF "" and close FF; 

	my %h; 
	tie %h, "DB_File", $dest, O_CREAT|O_RDWR, 0666, $DB_HASH or return; 

	open FF, $source or goto err1; 
	while (<FF>) {
		chomp; 
		my @a = split ' ', $_, 2; 
		$h{$a[0]} = $a[1]; 
	}
	close FF; 
err1:
	untie %h; 
}

# load value of KEY from FILE.db if it exists and key is defined there,
# else fallback to source text FILE
#
# return value or undef if not there
#
sub load_value {			## file, key
	my $file = shift; 

	my $key = shift; 
	my $hash_file = $file . ".db"; 

	# run 1 in 50 times
	if (!int(rand(50))) {
		my $mod = -M $hash_file;
		if (!defined $mod || -M $file < $mod) {
			hashify($file, $hash_file);
		}
	}
	my $val; 
	my %h; 
	if (tie %h, "DB_File", $hash_file, O_RDONLY, 0444, $DB_HASH) {
		$val = $h{$key}; 
		untie %h; 
	}
	defined $val and return $val; 
	local ($_, $., *FF); 
	open FF, $file or return undef; 
	while (<FF>) {
		chomp; 
		my @a = split ' ', $_, 2;
		if ($a[0] eq $key) {
			$val = $a[1]; 
			last; 
		}
	}
	close FF; 
	return $val; 
}

## TEST
my $v = load_value("zz_zz", "foo"); 
print defined $v ? $v : "undef", "\n"; 
exit; 
