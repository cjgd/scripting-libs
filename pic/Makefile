# T is the target to test
# x.ps is the same PS file to produce 
#
# usage might be: make T=samples/k7.pic
#
T = samples/lamp.pic

all: x.ps
	@/bin/echo -ne '\07'

# produce a temp x.ps_, and only when it's done, move into x.ps
# (so, x.ps will not be a 0 byte during a while)
#
x.ps_ : $(T)
	groff -p -Tps < $(T) > $@ 

x.ps: x.ps_
	cp -f x.ps_ x.ps

clean: 
	rm -f x.ps x.ps_
