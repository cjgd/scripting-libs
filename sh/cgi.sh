# cgi.sh -- parse cgi data... 

# $Id$ 
# Carlos Duarte <cgd@mail.teleweb.pt>, 990219

# parse cgi data, and sets CGI_xxx to its value, where xxx is the cgi var name
# CGI_ALL contains all variables got
# 
# use: 
# 	cgi_parse
# 	echo CGI_USER
# 	if $CGI_PASS != "xpto"; then 	
# 		echo bad password
# 	fi
# 

test -r /cdua/libs/sh/mktemp.sh && . /cdua/libs/sh/mktemp.sh
cgi_parse() {
	tmp=/tmp/c.$$-
	test x"$mktemp" != x && tmp=`eval "$mktemp"`

	case "$REQUEST_METHOD" in
	GET)	echo "$QUERY_STRING" ;;
	POST)	cat ;;
	*)
		if test x"$QUERY_STRING" != x; then
			echo "$QUERY_STRING"
		else 
			test x$CONTENT_LENGTH = x && CONTENT_LENGTH=0
			dd bs=1 count=$CONTENT_LENGTH 2>/dev/null
		fi
	esac | 
	awk -F"&" 'BEGIN {
		q = sprintf("%c", 39) # single quote
		H["0"] =  0; H["1"] =  1; H["2"] =  2; H["3"] =  3; 
		H["4"] =  4; H["5"] =  5; H["6"] =  6; H["7"] =  7; 
		H["8"] =  8; H["9"] =  9; H["A"] = 10; H["B"] = 11; 
		H["C"] = 12; H["D"] = 13; H["E"] = 14; H["F"] = 16; 
	}
	function decode(s,	pos,n,t) {
		gsub(/\+/, " ", s)
		pos = 1
		while ((n = match(substr(s, pos), /%../)) != 0) {
			t = t substr(s, pos, n-1)
			pos += n+2
			t = t sprintf("%c",
			 16*H[toupper(substr(s,pos-2,1))]+H[toupper(substr(s,pos-1,1))])
		}
		t = t substr(s, pos)
		return t
	}
	{
		for (i=1;i<=NF;i++) {
			split($i, a, /=/)
			var=decode(a[1])
			val=decode(a[2])
			gsub(/'\''/, q "\\" q q, val)
			printf "CGI_%s=%s%s%s\n", var, q, val, q
			all[++k] = "CGI_" var
		}
	} 
	END {
		printf "CGI_ALL=\""
		for (i=1; i<=k; i++)
			printf "%s ", all[i]
		print "\"\n"
	}' > $tmp 
	. $tmp
	rm -f $tmp
}

## test 
#QUERY_STRING="NAME=%22carlos%20duarte%22&BY=5%2d2%2d74"
#cgi_parse
#for i in $CGI_ALL; do
#	eval echo \$i = \$$i
#done
