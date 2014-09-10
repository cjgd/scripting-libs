#! /bin/sed -f

# incr.sed -- increment a number
# $Id$ 
# Carlos Duarte <cgd@mail.teleweb.pt>, 960719/990607

# first saw this on a script written by:
# Bruno <Haible@ma2s2.mathematik.uni-karlsruhe.de>

# heavily modified -- cgd

# pat space contains a number only

# 1999 -> 1:000
s/$/:/
td
:d
s/9:/:0/
td

# incr the guy
s/8:/9/
s/7:/8/
s/6:/7/
s/5:/6/
s/4:/5/
s/3:/4/
s/2:/3/
s/1:/2/
s/0:/1/
s/:/1/
