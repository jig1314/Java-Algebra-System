#
# jython for jas example integer programming.
# $Id$
#
# CLO2, p370
# 4 A + 5 B + C = 37
# 2 A + 3 B + D = 20
#
# max: 11 A + 15 B
#

import sys;

from jas import Ring

r = Ring( "Rat(w1,w2,w3,w4,z1,z2) W( (0,0,0,0,1,1),(1,1,2,2,0,0) )" );
print "Ring: " + str(r);
print;


ps = """
( 
 ( z1^4 z2^2 - w1 ),
 ( z1^5 z2^3 - w2 ),
 ( z1 - w3 ),
 ( z2 - w4 )
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
 ( z1^37 z2^20 )
) 
""";

fp = r.ideal( pf );
print "Ideal: " + str(fp);
print;

nf = fp.NF(rg);
print "NFs: " + str(nf);
print;


