# filename.sh -- get the filename portion from a path
# $Id$
# Carlos Duarte <cgd@mail.teleweb.pt>, 960909/990221

# % from end
# # from begin
# x  min match
# xx max match
# 

# does this shell supports %% ## substitutions?
exec 4>&2
exec 2>/dev/null
exec 5>&1
exec 1>/dev/null
a="123"
echo ${a%3}
b=$?
exec 2>&4
exec 4>&-
exec 1>&5
exec 5>&-

if test $b -eq 0; then
	filename () {
		tpath="${1%/}"
		test "$tpath" = "$1" && echo "${1##*/}"
	}

	dirname () {
		echo "${1%/*}"
	}
else
	filename () {
		echo "$1" | sed -e '/\/$/d' -e 's%^.*/%%'
	}

	dirname () {
		echo "$1" | sed -e 's%/[^/]*$%%'
	}
fi

## test
#filename /opt/foo/bar
#dirname /opt/foo/bar
