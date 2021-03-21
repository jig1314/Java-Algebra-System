#
# jython examples for jas.
# $Id$
#

from jas import PolyRing, QQ
from jas import startLog

# trinks 7 example

r = PolyRing( QQ(), "B,S,T,Z,P,W", PolyRing.lex); # or PolyRing.grad
print "PolyRing: " + str(r);
print;

ff = [
 45 * P + 35 * S - 165 * B - 36, 
 35 * P + 40 * Z + 25 * T - 27 * S, 
 15 * W + 25 * S * P + 30 * Z - 18 * T - 165 * B**2, 
 - 9 * W + 15 * T * P + 20 * S * Z, 
 P * W + 2 * T * Z - 11 * B**3, 
 99 * W - 11 * B * S + 3 * B**2,
 B**2 + (33,50) * B + (2673,10000)
];

f = r.ideal( "", ff );
print "Ideal: " + str(f);
print;

#startLog();
g = f.GB();
print "Groebner base: " + str(g);
print;
