#
# jython examples for jas.
# $Id$
#

import sys

from java.lang import System

from jas import QQ, AN, RF, Ring, PolyRing
from jas import terminate, startLog

# polynomial examples: factorization over Q(sqrt(2))(x)(sqrt(x))[y]

Q = PolyRing(QQ(),"w2",PolyRing.lex);
print "Q     = " + str(Q);
[e,a] = Q.gens();
print "e     = " + str(e);
print "a     = " + str(a);

root = a**2 - 2;
print "root  = " + str(root);
Q2 = AN(root,field=True);
print "Q2    = " + str(Q2.factory());
[one,w2] = Q2.gens();
#print "one   = " + str(one);
#print "w2    = " + str(w2);
print;

Qp = PolyRing(Q2,"x",PolyRing.lex);
print "Qp    = " + str(Qp);
[ep,wp,ap] = Qp.gens();
#print "ep    = " + str(ep);
#print "wp    = " + str(wp);
#print "ap    = " + str(ap);
print;

Qr = RF(Qp);
print "Qr    = " + str(Qr.factory());
[er,wr,ar] = Qr.gens();
#print "er    = " + str(er);
#print "wr    = " + str(wr);
#print "ar    = " + str(ar);
print;

Qwx = PolyRing(Qr,"wx",PolyRing.lex);
print "Qwx   = " + str(Qwx);
[ewx,wwx,ax,wx] = Qwx.gens();
#print "ewx   = " + str(ewx);
print "ax    = " + str(ax);
#print "wwx   = " + str(wwx);
print "wx    = " + str(wx);
print;

rootx = wx**2 - ax;
print "rootx = " + str(rootx);
Q2x = AN(rootx,field=True);
print "Q2x   = " + str(Q2x.factory());
[ex2,w2x2,ax2,wx] = Q2x.gens();
#print "ex2   = " + str(ex2);
#print "w2x2  = " + str(w2x2);
#print "ax2   = " + str(ax2);
#print "wx    = " + str(wx);
print;

Yr = PolyRing(Q2x,"y",PolyRing.lex)
print "Yr    = " + str(Yr);
#is automatic: [e,w2,x,wx,y] = Yr.gens();
print "e     = " + str(one);
print "w2    = " + str(w2);
print "x     = " + str(x);
print "wx    = " + str(wx);
print "y     = " + str(y);
print;

f = ( y**2 - x ) * ( y**2 - 2 );
#f = ( y**2 - x )**2 * ( y**2 - 2 )**3;
#f = ( y**4 - x * 2 );
#f = ( y**7 - x * 2 );
#f = ( y**2 - 2 );
#f = ( y**2 - x );
#f = ( w2 * y**2 - 1 );
#f = ( y**2 - 1/x );
#f = ( y**2 - (1,2) );
#f = ( y**2 - 1/x ) * ( y**2 - (1,2) );

print "f = ", f;
print;

#sys.exit();

startLog();

t = System.currentTimeMillis();
G = Yr.factors(f);
t = System.currentTimeMillis() - t;
#print "G = ", G;
#print "factor time =", t, "milliseconds";

#sys.exit();

print "f    = ", f;
g = one;
for h, i in G.iteritems():
    if i > 1:
        print "h**i = ", h, "**" + str(i);
    else:
        print "h    = ", h;
    h = h**i;
    g = g*h;
#print "g = ", g;
print;

if cmp(f,g) == 0:
    print "factor time =", t, "milliseconds,", "isFactors(f,g): true" ;
else:
    print "factor time =", t, "milliseconds,", "isFactors(f,g): ",  cmp(f,g);
print;

terminate();
sys.exit();

t = System.currentTimeMillis();
G = Yr.factors(f);
t = System.currentTimeMillis() - t;
#print "G = ", G;
print "2 factor time =", t, "milliseconds";

t = System.currentTimeMillis();
G = Yr.factors(f);
t = System.currentTimeMillis() - t;
#print "G = ", G;
print "3 factor time =", t, "milliseconds";

#startLog();
terminate();
