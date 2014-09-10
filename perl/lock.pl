#! /usr/bin/perl

# lock.pl -- open and lock a file
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990616/990815

use strict; 
use Fcntl ':flock';

# open_lock \*FF, "xpto"; opens xpto for read/write, and locks it. 
# ret 1 if ok, 0 otherwise
#
sub open_lock {
	my $fh = shift; 
	my $file = shift; 
	my $bored = 6; # max secs to wait

	if ( ! -e $file ) {
		$file = ">$file";
	} else {
		$file = "+<$file";
	}

	open($fh, $file) or return 0; 

	while (!flock($fh, LOCK_EX|LOCK_NB)) {
		$bored-- == 0 and do {
			close $fh; 
			return 0; 
		}; 
		sleep 1; 
	}
	return 1; 
}

# close_lock \*FF; close FF and unlocks it. 
# ret 1 if ok, 0 otherwise
#
sub close_lock {
	my $fh = shift; 
	my $ok = 1; 
	flock($fh, LOCK_UN) or $ok = 0; 
	close($fh) or $ok = 0; 
	return $ok; 
}

### test
my $n_procs = 30; 
my $n_seq   = 99; 
my $test_file = "/tmp/xx"; 

my $count = 0; 
open FF, ">$test_file" and close FF; ## truncates file
while (++$count <= $n_procs) {
	next if (fork);

	open_lock \*FF, "$test_file" or die "can't open/lock $test_file: $!"; 
	##open FF, ">>$test_file" or die "open $test_file: $!"; 
	seek FF, 0, 2; # seek to end
	my $ofh = select FF; $| = 1; select $ofh;   # no flush
	for (my $i = 1; $i <= $n_seq; $i++) {
		print FF "$count: $i\n"; 
	}
	close_lock \*FF; 
	##close FF; 
	exit; 
}
wait; 
my $err; 
open FF, "$test_file" or die "can't read from $test_file: $!"; 
my ($cur_n, $cur_seq) = (undef, 1); 
while (<FF>) {
	my ($n, $seq) = /^(\d+)[^\d]+(\d+)/; 
	defined $cur_n or $cur_n = $n; 
	if ($n != $cur_n || $seq != $cur_seq) {
		print "$test_file:$.: $_ >>$cur_n: $cur_seq ... expected\n"; 
		$err++; 
		last; 
	}
	if (++$cur_seq > $n_seq) {
		undef $cur_n; 
		$cur_seq = 1; 
	}
}
close FF; 
$err or print "OK\n"; 
