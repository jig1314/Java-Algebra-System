#
# jython examples for jas.
# $Id$
#

from jas import SolvableModule
from jas import SolvableSubModule

# Quantum plane example

rsan = """
AN[ (i) (i^2 + 1) ] (Y,X,x,y) G
RelationTable
(
 ( y ), ( x ), ( {i} x y )
 ( X ), ( Y ), ( {i} Y X )
)
""";

rsc = """
C(Y,X,x,y) G |2|
RelationTable
(
 ( y ), ( x ), ( 0i1 x y )
 ( X ), ( Y ), ( 0i1 Y X )
)
""";

r = SolvableModule( rsc );
#r = SolvableModule( rsan );
print "SolvableModule: " + str(r);
print;


ps = """
(
 ( ( x + 1 ), ( y ) ),
 ( ( x y ), ( 0 ) ),
 ( ( x - X ), ( x - X ) ),
 ( ( y - Y ), ( y - Y ) )
)
""";

f = SolvableSubModule( r, ps );
print "SolvableSubModule: " + str(f);
print;


flg = f.leftGB();
print "seq left GB:", flg;
print;


ftg = f.twosidedGB();
print "seq twosided GB:", ftg;
print;

# split term order not supported for rightGB
