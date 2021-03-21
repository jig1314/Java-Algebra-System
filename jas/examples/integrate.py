#
# jython examples for jas.
# $Id$
#

import sys

from java.lang import System

from jas import Ring, RF, QQ, PolyRing
from jas import terminate, startLog

# elementary integration

r = PolyRing(QQ(),"x",PolyRing.lex);
print "r = " + str(r);
rf = RF(r);
print "rf = " + str(rf.factory());
[one,x] = rf.gens();
print "one   = " + str(one);
print "x     = " + str(x);
print;

#f = 1 / ( 1 + x**2 );

#f = x**2 / ( x**2 + 1 );

#f = 1 / ( x**2 - 2 );
#f = 1 / ( x**3 - 2 );

#f = ( x + 3 ) / ( x**2- 3 * x - 40 );

f = ( x**7 - 24 * x**4 - 4 * x**2 + 8 * x - 8 ) / ( x**8 + 6 * x**6 + 12 * x**4 + 8 * x**2 );


print "f = ", f;
print;

startLog();

t = System.currentTimeMillis();
e1 = r.integrate(f);
t = System.currentTimeMillis() - t;
print "e1 = ", e1;
## print "e1.toScript() = ";
## for a in e1.logarithm:
##     print a.toScript();
print "integration time =", t, "milliseconds";
print 

t = System.currentTimeMillis();
e2 = f.integrate();
t = System.currentTimeMillis() - t;
print "e2 = ", e2;
print "integration time =", t, "milliseconds";
print 

#startLog();
terminate();
