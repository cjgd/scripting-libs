# tty.pl -- routines to deal with terminal
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 991101

use strict; 

{my $tty_data; 
sub tty_save {
	$tty_data = `stty -g </dev/tty`;
	chomp $tty_data;
}

sub tty_canon {
	system "stty -icanon min 1 -echo </dev/tty";
}

sub tty_restore {
	$tty_data and system "stty $tty_data </dev/tty";
}}

### test
tty_save(); 
tty_canon(); 
for (;;) {
	print "q for quit: "; 
	my $c = getc STDIN; 
	print "$c was pressed\n"; 
	lc $c eq "q" and last; 
}
tty_restore(); 
print "tty restored: "; 
getc STDIN; 
