# can_exec.pl -- check if a command is executable in PATH
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 991101

use strict; 

# check if PROG_NAME is executable on path
# return undef if it isn't, else the absolute pathname for it
#
sub can_exec { 			# $prog_name
	local $_ = shift; 
	for my $p (split /:/, $ENV{"PATH"}) {
		-x "$p/$_" and return "$p/$_"; 
	}
	return undef; 
}

## TEST
can_exec 'ls' and print "ls ok\n"; 
can_exec 'foo' or print "foo not ok\n"; 
print can_exec('mail'), "\n"; 
