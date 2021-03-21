#
# jython examples for jas.
# $Id$
#

from jas import SolvableRing

# ? example

rs = """
     Rat(a,b,e1,e2,e3) L
     RelationTable
     (
       ( e3 ), ( e1 ), ( e1 e3 - e1 ),
       ( e3 ), ( e2 ), ( e2 e3 - e2 )
     )
""";

r = SolvableRing( rs );
print "SolvableRing: " + str(r);
print;

ps = """
(
 ( e1 e3^3 + e2^10 - a ),
 ( e1^3 e2^2 + e3 ),
 ( e3^3 + e3^2 - b )
)
""";

f = r.ideal( ps );
print "SolvIdeal: " + str(f);
print;

from edu.jas.gbufd import SolvableSyzygySeq;

R = SolvableSyzygySeq(r.ring.coFac).resolution( f.pset );

for i in range(0,R.size()): 
   print "\n %s. resolution" % (i+1);
   print "\n", R[i];

