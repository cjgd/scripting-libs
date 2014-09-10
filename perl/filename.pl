# filename.pl -- routines for work with file names
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 991101

use strict; 

# 'rise.mp3' -> 'mp3'
sub get_ext {
	local $_ = shift; 
	s/^.*\.//; 
	return lc $_; 
}

# '/bin/mail' -> 'mail'
sub basename {
	local $_ = shift; 
	s#^.*/##; 
	return $_; 
}
