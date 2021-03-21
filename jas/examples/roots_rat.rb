#
# jruby examples for jas.
# $Id$
#

require "examples/jas"

# polynomial examples: real roots over Q

r = PolyRing.new(QQ(),"x",PolyRing.lex);
puts "Ring: " + str(r);
puts;

#automatic: one,x = r.gens();


f1 = x * ( x - 1 ) * ( x - 2 ) * ( x - 3 ) * ( x - 4 ) * ( x - 5 ) * ( x - 6 ) * ( x - 7 ) ;

f2 = ( x - 1/2 ) * ( x - 1/3 ) * ( x - 1/4 ) * ( x - 1/5 ) * ( x - 1/6 ) * ( x - 1/7 ) ;

f3 = ( x - 1/2**2 ) * ( x - 1/2**3 ) * ( x - 1/2**4 ) * ( x - 1/2**5 ) * ( x - 1/2**6 ) * ( x - 1/2**7 ) ;

#f = f1 * f2 * f3;
f = f1 * f2;
#f = f1 * f3;
#f = f2 * f3;
#f = f3;

#f = ( x**2 - 2 );

puts "f = " + f.to_s;
puts;

#startLog();

t = System.currentTimeMillis();
#rr = r.realRoots(f);
rr = f.realRoots();
t = System.currentTimeMillis() - t;
#puts "rr = " + str(rr);
puts "rr = " + rr.map{ |a| str(a.elem.ring.getRoot()) }.join(",\n "); 
puts "real roots time = " + str(t) + " milliseconds";
puts

eps = QQ(1,10) ** (BigDecimal::DEFAULT_PRECISION-3);
puts "eps = " + str(eps);

t = System.currentTimeMillis();
rr = r.realRoots(f,eps);
t = System.currentTimeMillis() - t;
#puts "rr = ", [ str(r) for r in rr ];
puts "rr = " + rr.map{ |a| str(a.elem.decimalMagnitude())}.join(",\n "); 
puts "real roots time = " + str(t) + " milliseconds";
puts

startLog();
terminate();
