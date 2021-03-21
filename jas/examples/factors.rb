#
# jruby examples for jas.
# $Id$
#

require "examples/jas"

# polynomial examples: factorization over Z

r = PolyRing.new( ZZ(), "x", PolyRing.lex );

puts "Ring: " + str(r);
puts;

#is automatic: one,x = r.gens();

#f = x**15 - 1;
#f = x * ( x + 1 )**2 * ( x**2 + x + 1 )**3;
#f = x**6 - 3 * x**5 + x**4 - 3 * x**3 - x**2 - 3 * x+ 1;
#f = x**(3*11*11) + 3 * x**(2*11*11) - x**(11*11);
#f = x**(3*11*11*11) + 3 * x**(2*11*11*11) - x**(11*11*11);
#f = (x**2+1)*(x-3)*(x-5)**3;
#f = x**4 + 1;
#f = x**12 + x**9 + x**6 + x**3 + 1;
#f = x**24 - 1;
#f = x**20 - 1;
#f = x**22 - 1;
#f = x**8 - 40 * x**6 + 352 * x**4 - 960 * x**2 + 576;
#f = 362408718672000 * x**9 + 312179013226080 * x**8 - 591298435728000 * x**6 - 509344705789920 * x**5 - 1178946881112000 * x**2 - 4170783473878580 * x - 2717923400363451;

#f = 292700016000 * x**8 + 614670033600 * x**7 - 417466472400 * x**6 - 110982089400 * x**5 + 1185906158780 * x**4 - 161076194335 * x**3 + 204890011200 * x**2 - 359330651400 * x - 7719685302;

#f = x**10 - 212 * x**9 - 1760 * x**8 + 529 * x**7 - 93699 * x**6 - 726220 * x**5 + 37740 * x**4 + 169141 * x**3 + 24517680 * x**2 - 9472740;

#f = x**4 - 1;
#f = x**3 - x**2 + x - 1;
#f = x**8 + 4 * x**6 + 8 * x**4 - 8 * x**2 + 4;
#f = x**15 + 122 * x**10 - 122 * x**5 - 1;
#f = x**16 + 272 * x**12 - 7072 * x**8 + 3207424 * x**4 + 12960000;

#f = x**16 + 16 * x**12 + 96 * x**8 + 256 * x**4 + 256;
#f = f * (x**24 + 272 * x**20 - 7072 * x**16 + 3207424 * x**12 + 12960000 * x**8);

f = (x**258 - 1);
#f = (x**258 - 1)/(x - 1);
#f = (x**100 - 1); #*(x - 1);
#f = (x**100 - 1)/(x - 1);

# Swinnerton-Dyer:
#f = x**8 - 236 * x**6 + 11678 * x**4 - 210428 * x**2 + 1261129;

puts "f = ", f;
puts;

#startLog();

t = System.currentTimeMillis();
#G = r.squarefreeFactors(f);
#G = r.factors(f);
G = f.factors();
t = System.currentTimeMillis() - t;
puts "G = ", str(G.map{ |h,i| str(h)+"**"+str(i)+" " });
#puts "G = ", G;
#puts "factor time =", t, "milliseconds";

puts;
puts "f    = " + str(f);
g = one;
for h, i in G do
    if i > 1 then
        puts "h**i = " + str(h) + "**" + str(i);
    else
        puts "h    = " + str(h);
    end
    h = h**i;
    g = g*h;
end
puts;
#puts "g = ", g;

if f == g then
    puts "factor time = " + str(t) + " milliseconds," + " isFactors(f,g): true" ;
else
    puts "factor time = " + str(t) + " milliseconds," + " isFactors(f,g): " + str(f==g);
end
puts;

startLog();
terminate();
