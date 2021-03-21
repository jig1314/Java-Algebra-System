#
# jython examples for jas.
# $Id$
#

import sys;

from jas import Ring, PolyRing, RF, ZZ, ZM, GF
from jas import startLog, terminate

#startLog();

# Lewis example 
# integral function coefficients

#r = Ring( "IntFunc(a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,e1,e2,e3) (t1,t2,t3) G" );
#r = Ring( "RatFunc(a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,e1,e2,e3) (t1,t2,t3) G" );
#r = PolyRing( RF(PolyRing(ZZ(),"a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,e1,e2,e3",PolyRing.lex)), "t1,t2,t3", PolyRing.grad );
#r = PolyRing( RF(PolyRing(GF(163),"a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,e1,e2,e3",PolyRing.grad)), "t1,t2,t3", PolyRing.grad );
r = PolyRing( PolyRing(GF(163),"a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,e1,e2,e3",PolyRing.grad), "t1,t2,t3", PolyRing.grad );
#no: r = PolyRing( RF(PolyRing(GF(5),"a1,a2,a3,b1,b2,b3,c1,c2,c3,d1,d2,d3,e1,e2,e3",PolyRing.grad)), "t1,t2,t3", PolyRing.grad );
print "Ring: " + str(r);
print;

ps = """
(
( { a1 } * t1^2 * t2^2 + { b1 } * t1^2 + { 2 c1 } * t1 * t2 + { d1 } * t2^2 + { e1 } ),
( { a2 } * t2^2 * t3^2 + { b2 } * t2^2 + { 2 c2 } * t2 * t3 + { d2 } * t3^2 + { e2 } ),
( { a3 } * t1^2 * t3^2 + { b3 } * t1^2 + { 2 c3 } * t1 * t3 + { d3 } * t3^2 + { e3 } )
) 
""";

#a1 = e2 + s22
#+ s27
#- s25
#- 2e * s2 + 2e * s7 - 2s2 * s7


f = r.ideal( ps );
print "ParamIdeal: " + str(f);
print;


# is optimized
#o = f.optimize();
#print "optimized Ideal: " + str(o);
#print;
#p = o.paramideal();
#p = p.optimizeCoeffQuot();
#print "optimized coeff Ideal: " + str(p);
#print;

sys.exit();

startLog();

rg = f.GB();
#rg = f.GB();
print "GB:", rg;
print;

#bg = rg.isGB();
#print "isGB:", bg;
print;

#startLog();
terminate();

