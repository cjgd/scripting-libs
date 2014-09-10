#! /bin/sed -f

# incr.sed -- increment a number
# $Id$ 
# Carlos Duarte <cgd@mail.teleweb.pt>, 960719/990607

# pat space contains a number only

# 1999 -> 1:000
s/$/:!0123456789/
td
:d
s/9:/:0/
td

# incr the guy
s/\(.\):\([^!]*\)![0-9]*\1\(.\)[0-9]*$/\3\2/
t

s/!.*//
s/:/1/

