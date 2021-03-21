#
# jython examples for jas.
# $Id$
#

import sys;
from java.lang import System

from jas import Ring, PolyRing
from jas import terminate
from jas import startLog
from jas import QQ, DD

# polynomial examples: real roots over Q for zero dimensional ideal `cyclic5'

r = PolyRing(QQ(),"a,b,c,d,e",PolyRing.lex);
print "Ring: " + str(r);
print;

#is automatic: [one,a,b,c,d,e] = r.gens();

f1 = a + b + c + d + e;
f2 = a*b + b*c + c*d + d*e + e*a;
f3 = a*b*c + b*c*d + c*d*e + d*e*a + e*a*b;
f4 = a*b*c*d + b*c*d*e + c*d*e*a + d*e*a*b + e*a*b*c;
f5 = a*b*c*d*e - 1;

print "f1 = ", f1;
print "f2 = ", f2;
print "f3 = ", f3;
print "f4 = ", f4;
print "f5 = ", f5;
print;

F = r.ideal( list=[f1,f2,f3,f4,f5] );

print "F = ", F;
print;

startLog();

t = System.currentTimeMillis();
R = F.realRoots();
t = System.currentTimeMillis() - t;
print;
print "R = ", R;
print;
print "real roots: ";
F.realRootsPrint()
print "real roots time =", t, "milliseconds";
print;

print "F = ", F;
print;

#startLog();
terminate();
