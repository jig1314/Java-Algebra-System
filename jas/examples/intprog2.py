#
# jython for jas example 2 integer programming.
# $Id$
#
# CLO2, p372
# 3 A - 2 B + C     = -1
# 4 A +   B - C - D = 5
#
# max: A + 1000 B + C + 100 D
#

import sys;

from jas import Ring

r = Ring( "Rat(w1,w2,w3,w4,t,z1,z2) W( (0,0,0,0,1,1,1),(1,1,2,2,0,0,0) )" );
print "Ring: " + str(r);
print;


ps = """
( 
 ( z1^3 z2^4 - w1 ),
 (  t^2 z2^3 - w2 ),
 (  t   z1^2 - w3 ),
 (  t   z1   - w4 ),
 (  t z1 z2  -  1 )
) 
""";

f = r.ideal( ps );
print "Ideal: " + str(f);
print;

rg = f.GB();
print "seq Output:", rg;
print;


pf = """
( 
 ( t z2^6 )
) 
""";

fp = r.ideal( pf );
print "Ideal: " + str(fp);
print;

nf = fp.NF(rg);
print "NFs: " + str(nf);
print;
