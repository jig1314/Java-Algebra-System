#
# jruby examples for jas.
# $Id$
#

require "examples/jas"

# trinks 7 example

r = Ring.new( "Rat(B,S,T,Z,P,W) L" );
puts "Ring: " + str(r);
puts;

ps = """
( 
 ( 45 P + 35 S - 165 B - 36 ), 
 ( 35 P + 40 Z + 25 T - 27 S ), 
 ( 15 W + 25 S P + 30 Z - 18 T - 165 B**2 ), 
 ( - 9 W + 15 T P + 20 S Z ), 
 ( P W + 2 T Z - 11 B**3 ), 
 ( 99 W - 11 B S + 3 B**2 ),
 ( B**2 + 33/50 B + 2673/10000 )
) 
""";

#f = SimIdeal.new( r, ps );
f = r.ideal( ps );
puts "Ideal: " + str(f);
puts;


#Katsura equations for N = 3:

#r = Ring.new( "Rat(u0,u1,u2,u3) L" );
#puts "Ring: " + str(r);
#puts;

ps = """
(
 u3*u3 + u2*u2 + u1*u1 + u0*u0 + u1*u1 + u2*u2 + u3*u3 - u0,
 u3*0 + u2*u3 + u1*u2 + u0*u1 + u1*u0 + u2*u1 + u3*u2 - u1,
 u3*0 + u2*0 + u1*u3 + u0*u2 + u1*u1 + u2*u0 + u3*u1 - u2,
 u3 + u2 + u1 + u0 + u1 + u2 + u3 - 1
)
""";

#f = r.ideal( ps );
#puts "Ideal: " + str(f);
#puts;

rg = f.GB();
puts "seq Output:" + str(rg);
puts;

#startLog();

java_import "edu.jas.poly.ModuleList";
java_import "edu.jas.gbufd.SyzygySeq";
java_import "edu.jas.gb.GroebnerBaseSeq";

s = SyzygySeq.new(r.ring.coFac).zeroRelations( rg.list );
sl = ModuleList.new(rg.pset.ring,s);

puts "syzygy:" + str(sl);
puts;

z = SyzygySeq.new(r.ring.coFac).isZeroRelation( s, rg.list );

print "is Syzygy ? "
if z
    puts "true"
else
    puts "false"
end
puts;

zg = sl;

for i in 1..(r.ring.nvar) 
   puts "\n #{i}. resolution";

   sl = zg;
   #mg = ModGroebnerBaseSeq.new(r.ring.coFac).GB(sl);
   mg = GroebnerBaseSeq.new().GB(sl);
   puts "Mod GB: " + str(mg);
   puts;

   zg = SyzygySeq.new(r.ring.coFac).zeroRelations(mg);
   puts "syzygies of Mod GB: " + str(zg);
   puts;

   #if ModGroebnerBaseSeq.new(r.ring.coFac).isGB( mg )
   if GroebnerBaseSeq.new().isGB( mg )
       puts "is GB";
   else
       puts "is not GB";
   end

   if SyzygySeq.new(r.ring.coFac).isZeroRelation(zg,mg)
       puts "is Syzygy";
   else
       puts "is not Syzygy";
   end

   if not zg
       break;
   end
end

terminate();
