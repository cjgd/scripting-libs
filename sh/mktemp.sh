# mktemp.sh -- get a temporary (and unique) filename

# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 990221

# exports var mktemp
# how to use: 
# 	. mktemp.sh 
# 
# 	tmp=`eval "$mktemp"`
# 	echo my temp file is : $tmp
# 
# tmp files, have the format : tmp.pid.sequence_nr

# find test file related flags: -e is enough, else, must check all other types
if test `test -e / 2>&1 | wc -l` -eq 0; then 
	mktemp_t="-e"
else
	o="-b"; test `test $o / 2>&1 | wc -l` -eq 0 && mktemp_t="$mktemp_t $o"
	o="-c"; test `test $o / 2>&1 | wc -l` -eq 0 && mktemp_t="$mktemp_t $o"
	o="-d"; test `test $o / 2>&1 | wc -l` -eq 0 && mktemp_t="$mktemp_t $o"
	o="-f"; test `test $o / 2>&1 | wc -l` -eq 0 && mktemp_t="$mktemp_t $o"
	o="-p"; test `test $o / 2>&1 | wc -l` -eq 0 && mktemp_t="$mktemp_t $o"
	o="-S"; test `test $o / 2>&1 | wc -l` -eq 0 && mktemp_t="$mktemp_t $o"
fi
##echo x "$mktemp_t"; exit

# find way to get next n
next_n='expr $n + 1'
test x$RANDOM != x$RANDOM && next_n='echo $RANDOM'

mktemp='
	n=0
	eval tmpfile=/tmp/tmp.$$
	while : ; do 
		n=`'$next_n'`
		for t in '$mktemp_t'; do
			test $t $tmpfile.$n && continue 2
		done
		break
	done
	echo $tmpfile.$n
'

## test
#t=`eval "$mktemp"`; echo $t; touch $t
#t=`eval "$mktemp"`; echo $t; touch $t
#t=`eval "$mktemp"`; echo $t; touch $t
