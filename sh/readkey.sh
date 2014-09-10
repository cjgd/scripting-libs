# readkey -- get keys on key touch

# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 960913/990221

readkey='
	x=`stty -g`
	#stty cbreak -echo
	stty raw -echo
	dd if=/dev/tty count=1 bs=1 2> /dev/null
	stty $x
'

# test
while test "$c" != "q"; do 
	echo 'press a key [q to quit]: ' | tr -d \\n 
	c=`eval "$readkey"`
	echo "$c ... was what you have pressed"
done
