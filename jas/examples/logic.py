#
# jython examples for jas.
# $Id$
#

from jas import Ring, PolyRing, GF

# logic example from Kreutzer JdM 2008

#r = Ring( "Mod 2 (a,f,p,u) G" );
r = PolyRing( GF(2), "(a,f,p,u)", PolyRing.grad );
print "Ring: " + str(r);
print;

ks = """
(
 ( a^2 - a ),
 ( f^2 - f ),
 ( p^2 - p ),
 ( u^2 - u )
)
""";

ps = """
(
 ( p f + p ),
 ( p u + p + u + 1 ),
 ( a + u + 1 ),
 ( a + p + 1 )
)
""";


k = r.ideal( ks );
p = r.ideal( ps );

f = k.sum( p );

print "Ideal: " + str(f);
print;

rg = f.GB();
print "Output:", rg;
print;


