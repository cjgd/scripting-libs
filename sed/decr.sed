#! /bin/sed -f

# decr.sed -- decrement a number
# $Id$ 
# Carlos Duarte <cgd@mail.teleweb.pt>, 960719/990607

# pat space contains a number only

# 2000 -> 2:999
s/$/:/
td
:d
s/0:/:9/
td

# decr the guy
s/1:/0/
s/2:/1/
s/3:/2/
s/4:/3/
s/5:/4/
s/6:/5/
s/7:/6/
s/8:/7/
s/9:/8/
s/^0//
