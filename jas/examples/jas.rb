# $Id$


=begin rdoc
Enhance Ruby Integer class by rational number construction.

Replace / by quo from Numeric to get Rational number.
=end
class Integer
  remove_method :/  # integer division
  alias / quo       # rational construction
end


=begin rdoc
jruby interface to JAS.
=end
module JAS

  module_function

require "java"
#require "mathn"

java_import "java.lang.System"
java_import "java.io.StringReader"
java_import "java.util.ArrayList"
java_import "java.util.Collections"

#java_import "org.apache.logging.log4j.Logger";

=begin rdoc
Configure the log4j system and start logging.

BasicConfigurator from log4j version 1 is no more supported, please use log4j2 configuration.
=end
def startLog()
    #puts "BasicConfigurator from log4j version 1 is no more supported, please use log4j2 configuration";
end

#startLog();

=begin rdoc
Mimic Python str() function.
=end
def str(s)
    return s.to_s;
end

java_import "edu.jas.kern.ComputerThreads";

=begin rdoc
Terminate the running thread pools.
=end
def terminate()
    ComputerThreads.terminate();
end

puts "Java Algebra System (JAS) version 2.7"

=begin rdoc
Turn off automatic parallel threads usage.
=end
def noThreads()
    puts "nt = ", ComputerThreads.NO_THREADS;
    ComputerThreads.setNoThreads(); #NO_THREADS = #0; #1; #true;
    puts "\nnt = ", ComputerThreads.NO_THREADS;
    puts
end

=begin rdoc
Inject variables for generators in given environment.
=end
def inject_gens(env) 
    env.class.instance_eval( "attr_accessor :generators;" )
    if env.generators == nil
       env.generators = {};
    end
    #puts "existing generators: " + env.generators.keys().join(", ");  
    redef = []
    for i in self.gens()
       begin 
          ivs = nameFromValue(i);
          if ivs == nil
             next
          end;
          #puts "string2: #{ivs} = " + ivs.class.to_s;
          #puts "string3: #{ivs} = " + (env.instance_eval( "#{ivs};" ));
          if env.generators[ ivs ] != nil
             #puts "redefining global variable #{ivs}";
             redef << ivs;
          end
          env.generators[ ivs ] = i;
          env.instance_eval( "def #{ivs}; @generators[ '#{ivs}' ]; end" )
          #puts "def #{ivs}; @generators[ '#{ivs}' ]; end"
          if self.class.auto_lowervar 
             first = ivs.slice(0,1);
             if first.count('A-Z') > 0
                first = first.downcase
                ivl = first + ivs.slice(1,ivs.length);
                puts "warning: '" + str(ivs) + "' additionaly renamed to '" + str(ivl) + "' to avoid constant semantics"
                if env.generators[ ivl ] != nil
                   #puts "redefining global variable #{ivl}";
                   redef << ivl;
                end
                env.instance_eval( "def #{ivl}; @generators[ '#{ivs}' ]; end" )
             end
          end
       rescue => e 
          #puts "error: #{ivs} = " + i.to_s + ", class = " + i.class.to_s;
          puts "error: #{ivs} = " + i.to_s + ", e = " + e.to_s;
       end
    end
    puts "globally defined variables: " + env.generators.keys().join(", ");  
    if redef.size > 0
       puts "WARN: redefined variables: " + redef.join(", ");  
    end
 end

=begin rdoc
Get a meaningful name from a value.

i ist the given value.
=end
def nameFromValue(i) 
    ivs = i.to_s
    #puts "string1: #{ivs} = " + ivs.class.to_s;
    ivs = ivs.gsub(" ","");
    ivs = ivs.gsub("\n","");
    ivs = ivs.gsub(",","");
    ivs = ivs.gsub("(","");
    ivs = ivs.gsub(")","");
    ivs = ivs.gsub("+","");
    #ivs = ivs.gsub("*","");
    ivs = ivs.gsub("/","div");
    #ivs = ivs.gsub("|","div");
    ivs = ivs.gsub("{","");
    ivs = ivs.gsub("}","");
    ivs = ivs.gsub("[","");
    ivs = ivs.gsub("]","");
    i = ivs.index("BigO");
    if i #and i > 0
       ivs = ivs[0,i];
       #puts "BigO index = #{i}";
    end
    if ivs == "1"
       ivs = "one"
    end
    if ivs[0] == "1"[0] and not ivs.match(/\A[0-9].*/)
       r = ivs[1,ivs.size-1].to_s;
       ivs = "one"
       if r != nil 
          ivs = ivs + r
       end
    end
    #if ivs[0,2] == "0i1"[0,2] or ivs[0,2] == "0I1"[0,2] 
    if ivs == "0i1" or ivs == "0I1"
       ivs = "i"
    end
    #puts "string: #{ivs} of " + i.to_s;
    if ivs.include?("|") or ivs.match(/\A[0-9].*/)
       #puts "string2: #{ivs} = " + ivs.class.to_s;
       ivs = nil
    end
    return ivs
end


# set output to Ruby scripting
java_import "edu.jas.kern.Scripting";
Scripting.setLang(Scripting::Lang::Ruby);

java_import "edu.jas.util.ExecutableServer";
java_import "edu.jas.structure.Power";
java_import "edu.jas.arith.BigInteger";
java_import "edu.jas.arith.BigRational";
java_import "edu.jas.arith.ModInteger";
java_import "edu.jas.arith.ModIntegerRing";
java_import "edu.jas.arith.ModLong";
java_import "edu.jas.arith.ModLongRing";
java_import "edu.jas.arith.ModInt";
java_import "edu.jas.arith.ModIntRing";
java_import "edu.jas.arith.BigDecimal";
java_import "edu.jas.arith.BigComplex";
java_import "edu.jas.arith.BigQuaternion";
java_import "edu.jas.arith.BigQuaternionRing";
java_import "edu.jas.arith.BigQuaternionInteger";
java_import "edu.jas.arith.BigOctonion";
java_import "edu.jas.arith.Product";
java_import "edu.jas.arith.ProductRing";
java_import "edu.jas.arith.PrimeList";


=begin rdoc
Create JAS BigInteger as ring element.
=end
def ZZ(z=0)
    if z.is_a? RingElem
        z = z.elem;
    end
    if z == 0 
       r = Java::EduJasArith::BigInteger.new();
    else
       #puts "z = #{z} : #{z.class} " 
       r = Java::EduJasArith::BigInteger.new(z);
    end
    return RingElem.new(r);
end


=begin rdoc
Create JAS ModInteger as ring element.
=end
def ZM(m,z=0,field=false)
    if m.is_a? RingElem
        m = m.elem;
    end
    if z.is_a? RingElem
        z = z.elem;
    end
    if z != 0 and ( z == true or z == false )
        field = z;
        z = 0;
    end
    if m < ModLongRing::MAX_LONG 
      if m < ModIntRing::MAX_INT
        if field
          mf = ModIntRing.new(m,field);
        else
          mf = ModIntRing.new(m);
        end
        r = ModInt.new(mf,z);
      else
        if field
          mf = ModLongRing.new(m,field);
        else
          mf = ModLongRing.new(m);
        end
        r = ModLong.new(mf,z);
      end
    else
       if field
          mf = ModIntegerRing.new(m,field);
       else
          mf = ModIntegerRing.new(m);
       end
       r = ModInteger.new(mf,z);
    end
    return RingElem.new(r);
end

=begin rdoc
Create JAS ModLong as ring element.
=end
def ZML(m,z=0,field=false)
    return ZM(m,z,field);
end

=begin rdoc
Create JAS ModInt as ring element.
=end
def ZMI(m,z=0,field=false)
    return ZM(m,z,field);
end

=begin rdoc
Create JAS ModInteger as field element.
=end
def GF(m,z=0)
    return ZM(m,z,true);
end

=begin rdoc
Create JAS ModLong as field element.
=end
def GFL(m,z=0)
    return ZM(m,z,true);
end

=begin rdoc
Create JAS ModInt as field element.
=end
def GFI(m,z=0)
    return ZM(m,z,true);
end

=begin rdoc
Create JAS BigRational as ring element.
=end
def QQ(d=0,n=1)
    if d.is_a? Rational 
        if n != 1
            puts "#{n} ignored\n";
        end
        if d.denominator != 1
            n = d.denominator;
        end
        d = d.numerator;
    end
    if d.is_a? RingElem
        d = d.elem;
    end
    if n.is_a? RingElem
        n = n.elem;
    end
    if n == 1
        if d == 0
            r = BigRational.new();
        else
            r = BigRational.new(d);
        end
    else
        d = BigRational.new(d);
        n = BigRational.new(n);
        r = d.divide(n); # BigRational.new(d,n); only for short integers
    end
    return RingElem.new(r);
end

=begin rdoc
Create JAS BigComplex as ring element.
=end
def CC(re=BigRational.new(),im=BigRational.new())
    if re == 0
        re = BigRational.new();
    end
    if im == 0
        im = BigRational.new();
    end
    if re.is_a? Array 
        if re[0].is_a? Array 
            if re.size > 1
                im = QQ( re[1] );
            end
            re = QQ( re[0] );
        else
            re = QQ(re);
#        re = makeJasArith( re );
        end
    end
    if im.is_a? Array 
        im = QQ( im );
#        im = makeJasArith( im );
    end
    if re.is_a? Numeric
        re = QQ(re);
    end
    if im.is_a? Numeric
        im = QQ(im);
    end
    if re.is_a? RingElem
        re = re.elem;
    end
    if im.is_a? RingElem
        im = im.elem;
    end
    if im.isZERO()
        if re.isZERO()
            c = BigComplex.new();
        else
            c = BigComplex.new(re);
        end
    else
        c = BigComplex.new(re,im);
    end
    return RingElem.new(c);
end


=begin rdoc
Create JAS generic Complex as ring element.
=end
def CR(re=BigRational.new(),im=BigRational.new(),ring=nil)
    if re == 0
        re = BigRational.new();
    end
    if im == 0
        im = BigRational.new();
    end
    if re.is_a? Array 
        if re[0].is_a? Array 
            if re.size > 1
                im = QQ( re[1] );
            end
            re = QQ( re[0] );
        else
            re = QQ(re);
#        re = makeJasArith( re );
        end
    end
    if im.is_a? Array 
        im = QQ( im );
#        im = makeJasArith( im );
    end
    if re.is_a? RingElem
        re = re.elem;
    end
    if im.is_a? RingElem
        im = im.elem;
    end
    if ring == nil
        ring = re.factory();
    end
    r = ComplexRing.new(ring);
    if im.isZERO()
        if re.isZERO()
            c = Complex.new(r);
        else
            c = Complex.new(r,re);
        end
    else
        c = Complex.new(r,re,im);
    end
    return RingElem.new(c);
end


=begin rdoc
Create JAS BigDecimal as ring element.
=end
def DD(d=0)
    if d.is_a? RingElem
        d = d.elem;
    end
    if d.is_a? Float
        d = d.to_s;
    end
    #puts "d type(#{d}) = #{d.class}";
    if d == 0
       r = BigDecimal.new();
    else
       r = BigDecimal.new(d);
    end
    return RingElem.new(r);
end


=begin rdoc
Create JAS BigQuaternion as ring element.
=end
def Quat(re=BigRational.new(),im=BigRational.new(),jm=BigRational.new(),km=BigRational.new())
    if re == 0
        re = BigRational.new();
    end
    if im == 0
        im = BigRational.new();
    end
    if jm == 0
        jm = BigRational.new();
    end
    if km == 0
        km = BigRational.new();
    end
    if re.is_a? Numeric 
        re = QQ(re);
#        re = makeJasArith( re );
    end
    if im.is_a? Numeric 
        im = QQ( im );
    end
    if jm.is_a? Numeric
        jm = QQ( jm );
    end
    if km.is_a? Numeric
       kim = QQ( km );
#        im = makeJasArith( im );
    end
    if re.is_a? RingElem
        re = re.elem;
    end
    if im.is_a? RingElem
        im = im.elem;
    end
    if jm.is_a? RingElem
        jm = jm.elem;
    end
    if km.is_a? RingElem
        km = km.elem;
    end
    cf = BigQuaternionRing.new();
    c = BigQuaternion.new(cf, re,im,jm,km);
    return RingElem.new(c);
end


=begin rdoc
Create JAS BigOctonion as ring element.
=end
def Oct(ro=0,io=0)
    cf = BigQuaternionRing.new();
    if ro == 0
        ro = BigQuaternion.new(cf);
    end
    if io == 0
        io = BigQuaternion.new(cf);
    end
    if ro.is_a? Array 
        if ro[0].is_a? Array 
            if ro.size > 1
                io = QQ( ro[1] );
            end
            ro = QQ( ro[0] );
        else
            ro = QQ(ro);
#        re = makeJasArith( re );
        end
    end
    if io.is_a? Array 
        io = QQ( io );
#        im = makeJasArith( im );
    end
    if ro.is_a? RingElem
        ro = ro.elem;
    end
    if io.is_a? RingElem
        io = io.elem;
    end
    c = BigOctonion.new(ro,io);
    return RingElem.new(c);
end


=begin rdoc
Proxy for JAS ring elements.

Methods to be used as + - * ** / %.
=end
class RingElem
    include Comparable
    # the Java element object
    attr_reader :elem
    # the Java factory object
    attr_reader :ring

=begin rdoc
Constructor for ring element.
=end
    def initialize(elem)
        if elem.is_a? RingElem
            @elem = elem.elem;
        else
            @elem = elem;
        end
        begin
            @ring = @elem.factory();
        rescue
            @ring = @elem;
        end
        @elem.freeze
        @ring.freeze
        self.freeze
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        begin 
           return @elem.toScript();
        rescue 
           return @elem.to_s(); 
        end
    end

=begin rdoc
Convert to float.
=end
    def to_f()
        e = @elem;
        if e.is_a? BigInteger
            e = BigRational(e);
        end
        if e.is_a? BigRational
            e = BigDecimal(e);
        end
        if e.is_a? BigDecimal
            e = e.toString();
        end
        e = e.to_f();
        return e;
    end

=begin rdoc
Zero element of this ring.
=end
    def zero()
        return RingElem.new( @elem.factory().getZERO() );
    end

=begin rdoc
Test if this is the zero element of the ring.
=end
    def isZERO()
        return @elem.isZERO();
    end

=begin rdoc
Test if this is the zero element of the ring.
=end
    def zero?()
        return @elem.isZERO();
    end

=begin rdoc
One element of this ring.
=end
    def one()
        return RingElem.new( @elem.factory().getONE() );
    end

=begin rdoc
Test if this is the one element of the ring.
=end
    def isONE()
        return @elem.isONE();
    end

=begin rdoc
Test if this is the one element of the ring.
=end
    def one?()
        return @elem.isONE();
    end

=begin rdoc
Get the sign of this element.
=end
    def signum()
        return @elem.signum();
    end

=begin rdoc
Absolute value.
=end
    def abs()
        return RingElem.new( @elem.abs() ); 
    end

=begin rdoc
Negative value.
=end
    def -@()
        return RingElem.new( @elem.negate() ); 
    end

=begin rdoc
Positive value.
=end
    def +@()
        return self; 
    end

=begin rdoc
Coerce other to self
=end
    def coerce(other)
        s,o = coercePair(self,other);
        return [o,s]; # keep order for non-commutative
    end

=begin rdoc
Coerce type a to type b or type b to type a.
=end
    def coercePair(a,b)
        #puts "a type(#{a}) = #{a.class}\n";
        #puts "b type(#{b}) = #{b.class}\n";
        begin
            if not a.isPolynomial() and b.isPolynomial()
               #puts "b = " + str(b.isPolynomial());
               s = b.coerceElem(a);
               o = b;
            else
               s = a;
               o = a.coerceElem(b);
            end
        rescue => e
               #puts "e #{e.message}, a = #{a}";
            s = a;
            o = a.coerceElem(b);
        end
        #puts "s type(#{s}) = #{s.class}\n";
        #puts "o type(#{o}) = #{o.class}\n";
        return [s,o];
    end

=begin rdoc
Coerce other to self
=end
    def coerceElem(other)
        #puts "self  type(#{self}) = #{self.class}\n";
        #puts "other type(#{other}) = #{other.class}\n";
        if @elem.is_a? GenVector
            if other.is_a? Array 
                o = rbarray2arraylist(other,@elem.factory().coFac,rec=1);
                o = GenVector.new(@elem.factory(),o);
                return RingElem.new( o );
                end
        end
        if @elem.is_a? GenMatrix
            if other.is_a? Array 
                o = rbarray2arraylist(other,@elem.factory().coFac,rec=2);
                o = GenMatrix.new(@elem.factory(),o);
                return RingElem.new( o );
                end
        end
        if other.is_a? RingElem
            if isPolynomial() and not other.isPolynomial()
                #puts "other parse(#{@ring})\n";
                o = @ring.parse( other.elem.toString() ); # not toScript()
                return RingElem.new( o );
            end
            #puts "other type(#{other}) = #{other.class}\n";
            return other;
        end
        #puts "--1";
        if other.is_a? Array
           # assume BigRational or BigComplex
           # assume self will be compatible with them. todo: check this
           puts "other type(#{other})_3 = #{other.class}\n";
           o = makeJasArith(other);
           puts "other type(#{o})_4 = #{o.class}\n";
           ##o = BigRational.new(other[0],other[1]);
           if isPolynomial()
                o = @ring.parse( o.toString() ); # not toScript();
                #o = o.elem;
           elsif @elem.is_a? BigComplex
                o = CC( o );
                o = o.elem;
           elsif @elem.is_a? BigQuaternion
                o = Quat( o );
                o = o.elem;
           elsif @elem.is_a? BigOctonion
                o = Oct( Quat(o) );
                o = o.elem;
           elsif @elem.is_a? Product
                o = RR(@ring, @elem.multiply(o) ); # valueOf
                #puts "o = #{o}";
                o = o.elem;
           end
           puts "other type(#{o})_5 = #{o.class}\n";
           return RingElem.new(o);
        end
        # test if @elem is a factory itself
        if isFactory()
            if other.is_a? Integer
                o = @elem.fromInteger(other);
            elsif other.is_a? Rational 
                o = @elem.fromInteger( other.numerator );
                o = o.divide( @elem.fromInteger( other.denominator ) );
            elsif other.is_a? Float # ?? what to do ??
                o = @elem.parse( other.to_s );
                ##o = @elem.fromInteger( other.to_i );
            else
                puts "unknown other type(#{other})_1 = #{other.class}\n";
                o = @elem.parse( other.to_s );
            end
            return RingElem.new(o);
        end
        # @elem has a ring factory
        if other.is_a? Integer
            o = @elem.factory().fromInteger(other);
        elsif other.is_a? Rational 
            o = @elem.factory().fromInteger( other.numerator );
            o = o.divide( @elem.factory().fromInteger( other.denominator ) );
        elsif other.is_a? Float # ?? what to do ??
                o = @elem.factory().parse( other.to_s );
                if @elem.is_a? Product
                    o = RR(@ring, @elem.idempotent().multiply(o) ); # valueOf
                    o = o.elem;
                end
        else
                puts "unknown other type(#{other})_2 = #{other.class}\n";
                o = @elem.factory().parse( other.to_s );
        end
        return RingElem.new(o);
    end

=begin rdoc
Test if this is itself a ring factory.
=end
    def isFactory()
        f = @elem.factory();
        if @elem == f
            return true;
        else
            return false;
        end
    end

=begin rdoc
Test if this is a polynomial.
=end
    def isPolynomial()
        begin
            nv = @elem.ring.coFac; #nvar;
        rescue
            return false;
        end
        return true;
    end

=begin rdoc
Compare two ring elements.
=end
    def <=>(other)
        #s,o = coercePair(other);
        s,o = self, other
        return s.elem.compareTo( o.elem ); 
    end

=begin rdoc
Test if two ring elements are equal.
=end
    def ==(other)
        if not other.is_a? RingElem
           return false;
        end
        return (self <=> other) == 0; 
    end

=begin rdoc
Length of an element.
=end
    def len()
        return self.elem.length(); 
    end

=begin rdoc
Hash value.
=end
    def object_id()
        return @elem.hashCode(); 
    end

=begin rdoc
Multiply two ring elements.
=end
    def *(other)
        #puts "* self  type(#{self.elem}) = #{self.elem.class}\n";
        #puts "* other type(#{other.elem}) = #{other.elem.class}\n";
        s,o = coercePair(self,other);
        #puts "* s = #{s}, o = #{o}, s*o = #{s.elem.multiply(o.elem)}\n";
        return RingElem.new( s.elem.multiply( o.elem ) ); 
    end

=begin rdoc
Add two ring elements.
=end
    def +(other)
        #puts "+ self  type(#{self}) = #{self.elem.class}\n";
        #puts "+ other type(#{other}) = #{other.elem.class}\n";
        s,o = coercePair(self,other);
        return RingElem.new( s.elem.sum( o.elem ) ); 
    end

=begin rdoc
Subtract two ring elements.
=end
    def -(other)
        #puts "+ self  type(#{self}) = #{self.elem.class}\n";
        #puts "+ other type(#{other}) = #{other.elem.class}\n";
        s,o = coercePair(self,other);
        return RingElem.new( s.elem.subtract( o.elem ) ); 
    end

=begin rdoc
Divide two ring elements.
=end
    def /(other)
        s,o = coercePair(self,other);
        return RingElem.new( s.elem.divide( o.elem ) ); 
    end

=begin rdoc
Modular remainder of two ring elements.
=end
    def %(other)
        s,o = coercePair(self,other);
        return RingElem.new( s.elem.remainder( o.elem ) ); 
    end

=begin rdoc
Can not be used as power.
=end
    def ^(other)
        return nil;
    end

=begin rdoc
Power of this to other.
=end
    def **(other)
        #puts "pow other type(#{other}) = #{other.class}";
        if other.is_a? Integer
            n = other;
        else
            if other.is_a? RingElem
                n = other.elem;
                if n.is_a? BigRational
                  #puts "#{n.numerator()} / #{n.denominator()}, other.elem = #{n}"
                  #todo (x**n.n)/(x**(-n.d))
                  if n.numerator().is_a? BigInteger
                    n = n.numerator().intValue() / n.denominator().intValue();
                  else
                    n = n.numerator() / n.denominator();
                  end
                end
                if n.is_a? BigInteger 
                    n = n.intValue();
                end
            end
        end
        if isFactory()
            p = Power.new(@elem).power( @elem, n );
        else
            p = Power.new(@elem.factory()).power( @elem, n );
            #puts "@elem**#{n} = #{p}, @elem = #{@elem}"
            #puts "@elem.ring = #{@elem.ring.toScript()}";
        end
        return RingElem.new( p ); 
    end

=begin rdoc
Test if two ring elements are equal.
=end
    def equal?(other)
        o = other;
        if other.is_a? RingElem
            o = other.elem;
        end
        return @elem.equals(o)
    end

=begin rdoc
Get the factory of this element.
=end
    def factory()
        fac = @elem.factory();
        begin
            nv = fac.nvar;
        rescue
            return RingElem.new(fac);
        end
        #return PolyRing(fac.coFac,fac.getVars(),fac.tord);
        return RingElem.new(fac);
    end

=begin rdoc
Get the generators for the factory of this element.
=end
    def gens()
        ll = @elem.factory().generators();
        #puts "L = #{ll}";
        nn = ll.map {|e| RingElem.new(e) };
        return nn;
    end

=begin rdoc
Monic polynomial.
=end
    def monic()
        return RingElem.new( @elem.monic() ); 
    end

=begin rdoc
Evaluate at a for power series or polynomial.
=end
    def evaluate(a)
        #puts "self  type(#{@elem}) = #{@elen.class}";
        #puts "a     type(#{a}) = #{a.class}";
        x = nil;
        if a.is_a? RingElem
            x = a.elem;
        end
        if a.is_a? Array 
            # assume BigRational or BigComplex
            # assume self will be compatible with them. todo: check this
            #x = makeJasArith(a);
            x = rbarray2arraylist(a);
        else
            x = rbarray2arraylist([a]);
        end
        begin
            if @elem.is_a? UnivPowerSeries
               e = @elem.evaluate(x[0]);
            else if @elem.is_a? MultiVarPowerSeries
                  e = @elem.evaluate(x);
               else  
                  #puts "x     = " + x[0].getClass().getSimpleName().to_s;
                  x = x.map{ |p| p.leadingBaseCoefficient() };
                  e = PolyUtil.evaluateAll(@ring.coFac, @elem, x);
               end
            end
        rescue => e
            raise RuntimeError, e.to_s; 
            e = 0;            
        end
        return RingElem.new( e );
    end

=begin rdoc
Integrate a power series or rational function with constant a.

a is the integration constant, r is for partial integration in variable r.
=end
    def integrate(a=0,r=nil)
        #puts "self  type(#{@elem}) = #{@elem.class}";
        #puts "a     type(#{a}) = #{a.class}";
        x = nil;
        if a.is_a? RingElem
            x = a.elem;
        end
        if a.is_a? Array 
            # assume BigRational or BigComplex
            # assume self will be compatible with them. todo: check this
            x = makeJasArith(a);
        end
        # power series
        begin 
            if r != nil
                e = @elem.integrate(x,r);
            else
                e = @elem.integrate(x);
            end
            return RingElem.new( e );
        rescue
            #pass;
        end
        cf = @elem.ring;
        begin
            cf = cf.ring;
        rescue
            #pass;
        end
        # rational function
        integrator = ElementaryIntegration.new(cf.coFac);
        ei = integrator.integrate(@elem); 
        return ei;
    end

=begin rdoc
Differentiate a power series.

r is for partial differentiation in variable r.
=end
    def differentiate(r=nil)
        begin
            if r != nil
                e = @elem.differentiate(r);
            else
                e = @elem.differentiate();
            end
        rescue
            e = @elem.factory().getZERO();
        end
        return RingElem.new( e );
    end

=begin rdoc
Random element.

n size for random element will be less than 2**n.
=end
    def random(n=3)
        if n.is_a? RingElem
           n = n.elem
        end
        return RingElem.new( @elem.factory().random(n) );
    end

=begin rdoc
Compute the greatest common divisor of this/self and b.
=end
    def gcd(b)
        a = @elem;
        if b.is_a? RingElem
            b = b.elem;
        else
            b = element( b );
            b = b.elem;
        end
        if isPolynomial()
           engine = Ring.getEngineGcd(@ring); 
           return RingElem.new( engine.gcd(a,b) );
        else
           return RingElem.new( a.gcd(b) );
        end
    end

=begin rdoc
Compute squarefree factors of polynomial.
=end
    def squarefreeFactors()
        a = @elem;
        if isPolynomial()
           sqf = Ring.getEngineSqf(@ring); 
           if sqf == nil 
              raise NotImplementedError, "squarefreeFactors not implemented for " + @ring.to_s;
           end
           cf = @ring.coFac;
           if cf.is_a? GenPolynomialRing
             e = sqf.recursiveSquarefreeFactors( a );
           else
             e = sqf.squarefreeFactors( a );
           end
           ll = {};
           for k in e.keySet()
               i = e.get(k);
               ll[ RingElem.new( k ) ] = i;
           end
           return ll;
        else
           raise NotImplementedError, "squarefreeFactors not implemented for " + a.to_s;
        end
    end

=begin rdoc
Compute irreducible factorization for modular, integer,
rational number and algebriac number coefficients.
=end
    def factors()
        a = @elem;
        if isPolynomial()
           factor = Ring.getEngineFactor(@ring); 
           if factor == nil 
              raise NotImplementedError, "factors not implemented for " + @ring.to_s;
           end
           cf = @ring.coFac;
           if cf.is_a? GenPolynomialRing
               e = factor.recursiveFactors( a );
           else
               e = factor.factors( a );
           end
           ll = {};
           for k in e.keySet()
               i = e.get(k);
               ll[ RingElem.new( k ) ] = i;
           end
           return ll;
        else
           raise NotImplementedError, "factors not implemented for " + a.to_s;
        end
    end

=begin rdoc
Compute absolute irreducible factorization for (modular,)
rational number coefficients.
=end
    def factorsAbsolute()
        a = @elem;
        if isPolynomial()
           factor = Ring.getEngineFactor(@ring); 
           if factor == nil 
              raise NotImplementedError, "factors not implemented for " + @ring.to_s;
           end
           begin
               ll = factor.factorsAbsolute( a );
##             ll = {};
##             for a in e.keySet()
##                 i = e.get(a);
##                 ll[ RingElem.new( a ) ] = i;
               return ll;
           rescue => e
               raise RuntimeError, "error factorsAbsolute " + @ring.to_s;
           end
        else
           raise NotImplementedError, "factors not implemented for " + a.to_s;
        end
    end

=begin rdoc
Compute real roots of univariate polynomial.
=end
    def realRoots(eps=nil)
        a = @elem;
        if eps.is_a? RingElem
            eps = eps.elem;
        end
        begin
            if eps == nil
                #rr = RealRootsSturm.new().realRoots( a );
                rr = RootFactory.realAlgebraicNumbers( a )
            else
                rr = RootFactory.realAlgebraicNumbers( a, eps );
                ## rr = RealRootsSturm.new().realRoots( a, eps );
                ## rr = [ r.toDecimal() for r in rr ];
                #rr = RealRootsSturm.new().approximateRoots(a,eps);
            end
            rr = rr.map{ |e| RingElem.new(e) };
            return rr;
        rescue => e
            puts "error " + str(e)
            return nil
        end
    end

=begin rdoc
Compute complex roots of univariate polynomial.
=end
    def complexRoots(eps=nil)
        a = @elem;
        if eps.is_a? RingElem
            eps = eps.elem;
        end
        cmplx = false;
        begin
            x = a.ring.coFac.getONE().getRe();
            cmplx = true;
        rescue => e
            #pass;
        end
        begin
            if eps == nil
                #rr = ComplexRootsSturm.new(a.ring.coFac).complexRoots( a );
                if cmplx
                   rr = RootFactory.complexAlgebraicNumbersComplex( a );
                else 
                   rr = RootFactory.complexAlgebraicNumbers( a );
                end
                #R = [ r.centerApprox() for r in R ];
            else
                ## rr = ComplexRootsSturm.new(a.ring.coFac).complexRoots( a, eps );
                ## rr = [ r.centerApprox() for r in rr ];
                ##rr = ComplexRootsSturm.new(a.ring.coFac).approximateRoots( a, eps );
                if cmplx
                   rr = RootFactory.complexAlgebraicNumbersComplex( a, eps );
                else
                   rr = RootFactory.complexAlgebraicNumbers( a, eps );
                end
            end
            rr = rr.map{ |y| RingElem.new(y) };
            return rr;
        rescue => e
            puts "error " + str(e)
            return nil
        end
    end

=begin rdoc
Compute algebraic roots, i.e. real and complex algebraic roots of univariate polynomial.
=end
    def algebraicRoots(eps=nil)
        a = @elem;
        if eps.is_a? RingElem
            eps = eps.elem;
        end
        begin
            if eps == nil
                ar = RootFactory.algebraicRoots( a );
            else
                ar = RootFactory.algebraicRoots( a, eps );
            end
            #no: ar = ar.map{ |y| RingElem.new(y) };
            return RingElem.new(ar); #??
        rescue => e
            puts "error " + str(e)
            return nil
        end
    end

=begin rdoc
Compute algebraic roots refinement.
=end
    def rootRefine(eps=nil)
        r = @elem;
        if eps.is_a? RingElem
            eps = eps.elem;
        end
        begin
            RootFactory.rootRefine( r, eps );
            #no: ar = ar.map{ |y| RingElem.new(y) };
            return RingElem.new(r); # ??
        rescue => e
            puts "error " + str(e)
            return nil
        end
    end

=begin rdoc
Compute decimal approximation of real and complex roots of univariate polynomial.
=end
    def decimalRoots(eps=nil)
        a = @elem;
        if eps.is_a? RingElem
            eps = eps.elem;
        end
        if a.is_a? Java::EduJasRoot::AlgebraicRoots
            a = a.p;
        end
        begin
            d = RootFactory.decimalRoots( a, eps );
            return RingElem.new(d); # ??
        rescue => e
            puts "error " + str(e)
            return nil
        end
    end

=begin rdoc
Roots of unity of real and complex algebraic numbers.
=end
    def rootsOfUnity()
        a = @elem;
        begin #Java::EduJasApplication::
            if a.is_a? AlgebraicRootsPrimElem
               d = RootFactoryApp.rootsOfUnity( a );
            else
               d = RootFactory.rootsOfUnity( a );
            end
            return RingElem.new(d); # ??
        rescue => e
            puts "error " + str(e)
            return nil
        end
    end

=begin rdoc
Root reduce of real and complex algebraic numbers.
Compute an extension field with a primitive element.
=end
    def rootReduce(other)
        a = @elem;
        b = other;
        if b.is_a? RingElem
            b = b.elem;
        end
        begin #Java::EduJasApplication::
            d = RootFactoryApp.rootReduce( a, b );
            return RingElem.new(d); # ??
        rescue => e
            puts "error " + str(e)
            return nil
        end
    end


=begin rdoc
Get the coefficients of a polynomial.
=end
    def coefficients()
        a = @elem;
        #L = [ c.toScriptFactory() for c in a.coefficientIterator() ];
        ll = a.coefficientIterator().map { |c| RingElem.new(c) }; 
        return ll
    end


#----------------
# Compatibility methods for Sage/Singular:
# Note: the meaning of lt and lm is swapped compared to JAS.
#----------------

=begin rdoc
Parent in Sage is factory in JAS.

Compatibility method for Sage/Singular.
=end
    def parent()
        return factory();
    end

=begin rdoc
Apply this to num.

Call syntax is ringElem.(num). Only for interger num.
=end
    def call(num)
        if num == 0 
            return zero();
        end
        if num == 1
            return one();
        end
        return RingElem.new( @ring.fromInteger(num) );
    end

=begin rdoc
Leading monomial of a polynomial.

Compatibility method for Sage/Singular.
Note: the meaning of lt and lm is swapped compared to JAS.
=end
    def lm()
        ev = @elem.leadingExpVector();
        return ev;
    end

=begin rdoc
Leading coefficient of a polynomial.

Compatibility method for Sage/Singular.
=end
    def lc()
        c = @elem.leadingBaseCoefficient();
        return RingElem.new(c);
    end

=begin rdoc
Leading term of a polynomial.

Compatibility method for Sage/Singular.
Note: the meaning of lt and lm is swapped compared to JAS.
=end
    def lt()
        ev = @elem.leadingMonomial();
        return Monomial.new(ev);
    end

=begin rdoc
Degree of a polynomial.
=end
    def degree()
        begin
            ev = @elem.degree();
        rescue
            return nil;
        end
        return ev;
    end

=begin rdoc
Coefficient ring of a polynomial.
=end
    def base_ring()
        begin
            ev = @elem.ring.coFac;
        rescue
            return nil;
        end
        return RingElem.new(ev);
    end

=begin rdoc
Test if this RingElem is field.
=end
    def is_field()
        return @ring.isField();
    end

=begin rdoc
All monomials of a polynomial.

Compatibility method for Sage/Singular.
=end
    def monomials()
        ev = @elem.getMap().keySet();
        return ev;
    end

=begin rdoc
Test if self divides other.

Compatibility method for Sage/Singular.
=end
    def divides(other)
        s,o = coercePair(self,other);
        return o.elem.remainder( s.elem ).isZERO(); 
    end

=begin rdoc
Create an ideal.

Compatibility method for Sage/Singular.
=end
    def ideal(list)
        r = Ring.new("",ring=self.ring); #,fast=true
        return r.ideal("",list=list);
    end

=begin rdoc
Quotient of ExpVectors.

Compatibility method for Sage/Singular.
=end
    def monomial_quotient(a,b,coeff=false)
        if a.is_a? RingElem
            a = a.elem;
        end
        if b.is_a? RingElem
            b = b.elem;
        end
        if coeff == false
            if a.is_a? GenPolynomial
                return RingElem.new( a.divide(b) );
            else
                return RingElem.new( GenPolynomial.new(@ring, a.subtract(b)) );
            end
        else
            # assume JAS Monomial
            c = a.coefficient().divide(b.coefficient());
            e = a.exponent().subtract(b.exponent())
            return RingElem.new( GenPolynomial.new(@ring, c, e) );
        end
    end

=begin rdoc
Test divide of ExpVectors.

Compatibility method for Sage/Singular.
=end
    def monomial_divides(a,b)
        #print "JAS a = " + str(a) + ", b = " + str(b);
        if a.is_a? RingElem
            a = a.elem;
        end
        if a.is_a? GenPolynomial
            a = a.leadingExpVector();
        end
        if not a.is_a? ExpVector
            raise ArgumentError, "No ExpVector given " + str(a) + ", " + str(b)
        end
        if b == nil
            return False;
        end
        if b.is_a? RingElem
            b = b.elem;
        end
        if b.is_a? GenPolynomial
            b = b.leadingExpVector();
        end
        if not b.is_a? ExpVector
            raise ArgumentError, "No ExpVector given " + str(a) + ", " + str(b)
        end
        return a.divides(b);
    end

=begin rdoc
Test if ExpVectors are pairwise prime.

Compatibility method for Sage/Singular.
=end
    def monomial_pairwise_prime(e,f)
        if e.is_a? RingElem
            e = e.elem;
        end
        if f.is_a? RingElem
            f = f.elem;
        end
        # assume JAS ExpVector
        c = e.gcd(f);
        return c.isZERO();
    end

=begin rdoc
Lcm of ExpVectors.

Compatibility method for Sage/Singular.
=end
    def monomial_lcm(e,f)
        if e.is_a? RingElem
            e = e.elem;
        end
        if f.is_a? RingElem
            f = f.elem;
        end
        # assume JAS ExpVector
        c = e.lcm(f);
        return c;
    end

=begin rdoc
Compute a normal form of self with respect to ff.

Compatibility method for Sage/Singular.
=end
    def reduce(ff)
        s = @elem;
        fe = ff.map {|e| e.elem };
        n = ReductionSeq.new().normalform(fe,s);
        return RingElem.new(n);
    end

#----------------
# End of compatibility methods
#----------------

end


java_import "edu.jas.poly.GenPolynomial";
java_import "edu.jas.poly.GenPolynomialRing";
java_import "edu.jas.poly.GenSolvablePolynomial";
java_import "edu.jas.poly.GenSolvablePolynomialRing";
java_import "edu.jas.poly.RecSolvablePolynomial";
java_import "edu.jas.poly.RecSolvablePolynomialRing";
java_import "edu.jas.poly.GenWordPolynomial";
java_import "edu.jas.poly.GenWordPolynomialRing";
java_import "edu.jas.poly.RecSolvableWordPolynomial";
java_import "edu.jas.poly.RecSolvableWordPolynomialRing";
java_import "edu.jas.poly.QLRSolvablePolynomial";
java_import "edu.jas.poly.QLRSolvablePolynomialRing";
java_import "edu.jas.poly.GenPolynomialTokenizer";
java_import "edu.jas.poly.TermOrder";
java_import "edu.jas.poly.TermOrderByName";
java_import "edu.jas.poly.OrderedPolynomialList";
java_import "edu.jas.poly.PolyUtil";
java_import "edu.jas.poly.TermOrderOptimization";
java_import "edu.jas.poly.PolynomialList";
java_import "edu.jas.poly.WordFactory";
java_import "edu.jas.poly.AlgebraicNumber";
java_import "edu.jas.poly.AlgebraicNumberRing";
java_import "edu.jas.poly.OrderedModuleList";
java_import "edu.jas.poly.ModuleList";
java_import "edu.jas.poly.Complex";
java_import "edu.jas.poly.ComplexRing";
java_import "edu.jas.application.RingFactoryTokenizer";

java_import "edu.jas.ufd.GreatestCommonDivisor";
java_import "edu.jas.ufd.GCDFactory";
java_import "edu.jas.application.FactorFactory";
java_import "edu.jas.ufd.SquarefreeFactory";
java_import "edu.jas.integrate.ElementaryIntegration";


=begin rdoc
Represents a JAS polynomial ring: GenPolynomialRing.

Methods to create ideals and ideals with parametric coefficients.
=end
class Ring
    # the Java factoy object, gcd engine, sqf engine, factorization engine
    attr_reader :ring, :engine, :sqf, :factor
    #:pset,

    @auto_inject = true
    @auto_lowervar = false

    class << self  # means add to class
       # inject variables into environment
       attr_accessor :auto_inject
       # avoid capital letter variables
       attr_accessor :auto_lowervar
    end


=begin rdoc
Ring constructor.

ringstr string representation to be parsed.
ring JAS ring object.
=end
    def initialize(ringstr="",ring=nil)
        if ring == nil
           sr = StringReader.new( ringstr );
           tok = RingFactoryTokenizer.new(sr);
           pfac = tok.nextPolynomialRing();
           #tok = GenPolynomialTokenizer.new(sr);
           #@pset = tok.nextPolynomialSet();
           @ring = pfac;
        else
           if ring.is_a? Ring
              @ring = ring.ring
           else 
              @ring = ring;
           end
        end
        # parameter ",fast=false" not possible w/o keyword params
        #if fast == true
        #   return
        #end
        @engine = Ring.getEngineGcd(@ring);
        @sqf = Ring.getEngineSqf(@ring);
        @factor = Ring.getEngineFactor(@ring);
        variable_generators()
        if self.class.auto_inject or self.class.superclass.auto_inject # sic!
           inject_variables();
        end
    end

=begin rdoc
Get the polynomial gcd engine implementation.

r is the given polynomial ring.
=end
    def Ring.getEngineGcd(r)
        if r.is_a? RingElem
            r = r.elem;
        end
        if not r.is_a? GenPolynomialRing
           return nil;
        end
        begin
           i = GCDFactory.getProxy(r.coFac);
           #i = GCDFactory.getImplementation(r.coFac);
        rescue => e
           i = nil
        end
        #puts "gcd engine: #{i}";
        return i;
    end

=begin rdoc
Get the polynomial squarefree engine implementation.

r is the given polynomial ring.
=end
    def Ring.getEngineSqf(r)
        if r.is_a? RingElem
            r = r.elem;
        end
        if not r.is_a? GenPolynomialRing
           return nil;
        end
        begin 
           i = SquarefreeFactory.getImplementation(r.coFac);
        rescue => e
           i = nil
        end
        #puts "sqf engine: #{i}";
        return i;
    end

=begin rdoc
Get the polynomial factorization engine implementation.

r is the given polynomial ring.
=end
    def Ring.getEngineFactor(r)
        if r.is_a? RingElem
            r = r.elem;
        end
        if not r.is_a? GenPolynomialRing
           return nil;
        end
        begin 
           i = FactorFactory.getImplementation(r.coFac);
        rescue => e
           i = nil
        end
        #puts "factor engine: #{i}";
        return i;
    end

=begin rdoc
Define instance variables for generators.
=end
    def variable_generators() 
       Ring.instance_eval( "attr_accessor :generators;" )
       @generators = {};
       for i in self.gens()
          begin 
             ivs = nameFromValue(i);
             if ivs != nil
                #puts "string: #{ivs} = " + ivs.class.to_s;
                if @generators[ ivs ] != nil
                   puts "redefining local variable #{ivs}";
                end
                @generators[ ivs ] = i;
                self.instance_eval( "def #{ivs}; @generators[ '#{ivs}' ]; end" )
             end
          rescue => e
             puts "ring error: #{ivs} = " + i.to_s + ", e = " + str(e);
             #pass
          end
       end
    #puts "locally defined generators: " + @generators.keys().join(", ");  
    end

=begin rdoc
Inject variables for generators in top level environment.
=end
    def inject_variables() 
        begin 
           require "irb/frame" # must be placed here
           bin = IRB::Frame.bottom(0);
           env = eval "self", bin;
           #puts "env = " + str(env)
           inject_gens(env)
        rescue => e
           puts "error: 'irb/frame' not found, e = " + str(e);
        end
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @ring.toScript();
    end

=begin rdoc
Test if two rings are equal.
=end
    def ==(other)
        if not other.is_a? Ring
           return false;
        end
        return @ring.equals(other.ring);
    end

=begin rdoc
Create an ideal.
=end
    def ideal(ringstr="",list=nil)
        return JAS::SimIdeal.new(self,ringstr,list);
    end

=begin rdoc
Create an ideal in a polynomial ring with parameter coefficients.
=end
    def paramideal(ringstr="",list=nil,gbsys=nil)
        return ParamIdeal.new(self,ringstr,list,gbsys);
    end

=begin rdoc
Get a power series ring from this ring.
=end
    def powerseriesRing()
        pr = MultiVarPowerSeriesRing.new(@ring);
        return MultiSeriesRing.new("",nil,pr);
    end

=begin rdoc
Get list of generators of the polynomial ring.
=end
    def gens()
        ll = @ring.generators();
        n = ll.map{ |e| RingElem.new(e) };
        return n;
    end

=begin rdoc
Get the one of the polynomial ring.
=end
    def one()
        return RingElem.new( @ring.getONE() );
    end

=begin rdoc
Get the zero of the polynomial ring.
=end
    def zero()
        return RingElem.new( @ring.getZERO() );
    end

=begin rdoc
Get a random polynomial.
=end
    def random(k=5,l=7,d=3,q=0.3)
        r = @ring.random(k,l,d,q);
        if @ring.coFac.isField()
            r = r.monic();
        end
        return RingElem.new( r );
    end

=begin rdoc
Create an element from a string or an object.
=end
    def element(poly)
        if not poly.is_a? String 
           begin
              if @ring == poly.ring 
                 return RingElem.new(poly);
              end
           rescue => e
              # pass
           end
           poly = str(poly);
        end
        i = SimIdeal.new( self, "( " + poly + " )" );
        list = i.pset.list;
        if list.size > 0
           return RingElem.new( list[0] );
        end
    end

=begin rdoc
Compute the greatest common divisor of a and b.
=end
    def gcd(a,b)
        if a.is_a? RingElem
            a = a.elem;
        else
            a = element( a );
            a = a.elem;
        end
        if b.is_a? RingElem
            b = b.elem;
        else
            b = element( b );
            b = b.elem;
        end
        cf = @ring.coFac;
        if cf.is_a? GenPolynomialRing
            e = @engine.recursiveGcd( a, b );
        else
            e = @engine.gcd( a, b );
        end
        return RingElem.new( e );
    end

=begin rdoc
Compute squarefree factors of polynomial.
=end
    def squarefreeFactors(a)
        if a.is_a? RingElem
            a = a.elem;
        else
            a = element( a );
            a = a.elem;
        end
        cf = @ring.coFac;
        if cf.is_a? GenPolynomialRing
            e = @sqf.recursiveSquarefreeFactors( a );
        else
            e = @sqf.squarefreeFactors( a );
        end
        ll = {};
        for a in e.keySet()
            i = e.get(a);
            ll[ RingElem.new( a ) ] = i;
        end
        return ll;
    end

=begin rdoc
Compute irreducible factorization for modular, integer,
rational number and algebriac number coefficients.
=end
    def factors(a)
        if a.is_a? RingElem
            a = a.elem;
        else
            a = element( a );
            a = a.elem;
        end
        begin
            cf = @ring.coFac;
            if cf.is_a? GenPolynomialRing
                e = @factor.recursiveFactors( a );
            else
                e = @factor.factors( a );
            end
            ll = {};
            for a in e.keySet()
                i = e.get(a);
                ll[ RingElem.new( a ) ] = i;
            end
            return ll;
        rescue => e
            puts "error " + str(e)
            return nil
        end
    end

=begin rdoc
Compute absolute irreducible factorization for (modular,)
rational number coefficients.
=end
    def factorsAbsolute(a)
        if a.is_a? RingElem
            a = a.elem;
        else
            a = element( a );
            a = a.elem;
        end
        begin
            ll = @factor.factorsAbsolute( a );
##             ll = {};
##             for a in e.keySet()
##                 i = e.get(a);
##                 ll[ RingElem.new( a ) ] = i;
            return ll;
        rescue => e
            puts "error in factorsAbsolute " + str(e)
            return nil
        end
    end

=begin rdoc
Compute real roots of univariate polynomial.
=end
    def realRoots(a,eps=nil)
        if not a.is_a? RingElem
            a = RingElem.new(a);
        end
        return a.realRoots(eps);
    end

=begin rdoc
Compute complex roots of univariate polynomial.
=end
    def complexRoots(a,eps=nil)
        if not a.is_a? RingElem
            a = RingElem.new(a);
        end
        return a.complexRoots(eps);
    end

=begin rdoc
Compute algebraic real and complex roots of univariate polynomial.
=end
    def algebraicRoots(a,eps=nil)
        if not a.is_a? RingElem
            a = RingElem.new(a);
        end
        return a.algebraicRoots(eps);
    end

=begin rdoc
Compute algebraic real and complex roots refinement.
=end
    def rootRefine(a,eps=nil)
        if not a.is_a? RingElem
            a = RingElem.new(a);
        end
        return a.rootRefine(eps);
    end

=begin rdoc
Compute deximal approximation of algebraic real and complex roots.
=end
    def decimalRoots(a,eps=nil)
        if not a.is_a? RingElem
            a = RingElem.new(a);
        end
        return a.decimalRoots(eps);
    end

=begin rdoc
Roots of unity of real and complex algebraic numbers.
=end
    def rootsOfUnity(a)
        if not a.is_a? RingElem
            a = RingElem.new(a);
        end
        return a.rootsOfUnity();
    end

=begin rdoc
Root reduce of real and complex algebraic numbers.
Compute an extension field with a primitive element.
=end
    def rootReduce(a, b)
        if not a.is_a? RingElem
            a = RingElem.new(a);
        end
        return a.rootReduce(b);
    end

=begin rdoc
Integrate rational function or power series.
=end
    def integrate(a)
        if not a.is_a? RingElem
            a = RingElem.new(a);
        end
        return a.integrate();
    end
end


=begin rdoc
Collection of JAS and other CAS term order names.

Defines names for term orders.
See {TermOrderByName}[http://krum.rz.uni-mannheim.de/jas/doc/api/edu/jas/poly/TermOrderByName.html].
=end
class Order < TermOrderByName
end


=begin rdoc
Represents a JAS polynomial ring: GenPolynomialRing.

Provides more convenient constructor. 
Then returns a Ring.
=end
class PolyRing < Ring

    # class instance variables != class variables
    @lex = Order::INVLEX
    @grad = Order::IGRLEX

    class << self  # means add to class
       # the Java term orderings
       attr_reader :lex, :grad
    end


=begin rdoc
Ring constructor.

coeff = factory for coefficients,
vars = string with variable names,
order = term order or weight matrix.
=end
    def initialize(coeff,vars,order=Order::IGRLEX)
        if coeff == nil
            raise ArgumentError, "No coefficient given."
        end
        cf = coeff;
        if coeff.is_a? RingElem
            cf = coeff.elem.factory();
        end
        if coeff.is_a? Ring
            cf = coeff.ring;
        end
        if vars == nil
            raise ArgumentError, "No variable names given."
        end
        names = vars;
        if vars.is_a? String
           names = GenPolynomialTokenizer.variableList(vars);
        end
        nv = names.size;
        to = Order::IGRLEX; #self.class.grad;
        if order.is_a? TermOrder
            to = order;
        end
        if order.is_a? Array
            to = TermOrder.reverseWeight(order);
        end
        @ring = GenPolynomialRing.new(cf,nv,to,names);
        #@ring = tring;
        super("",@ring) 
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @ring.toScript();
    end

end


=begin rdoc
Create JAS AlgebraicNumber as ring element.
=end
def AN(m,z=0,field=false,pr=nil)
    if m.is_a? RingElem
        m = m.elem;
    end
    if z.is_a? RingElem
        z = z.elem;
    end
    if z != 0 and ( z == true or z == false )
        field = z;
        z = 0;
    end
    #puts "m.getClass() = " + str(m.getClass().getName());
    #puts "field = " + str(field);
    if m.is_a? AlgebraicNumber
        mf = AlgebraicNumberRing.new(m.factory().modul,m.factory().isField());
    else
        if field
            mf = AlgebraicNumberRing.new(m,field);
        else
            mf = AlgebraicNumberRing.new(m);
        end
    end
    #puts "mf = " + mf.toString();
    if z == 0
        r = AlgebraicNumber.new(mf);
    else
        r = AlgebraicNumber.new(mf,z);
    end
    return RingElem.new(r);
end


java_import "edu.jas.arith.PrimeInteger";
java_import "edu.jas.ufd.PolyUfdUtil";

$finiteFields = Hash.new;

=begin rdoc
Create JAS Finite Field element as ring element. 
FF has p<sup>n</sup> elements.
=end
def FF(p,n,z=0)
    if p.is_a? RingElem
        p = p.elem;
    end
    if n.is_a? RingElem
        n = n.elem;
    end
    if z.is_a? RingElem
        z = z.elem;
    end
    if z.is_a? AlgebraicNumber
        z = z.val;
        #puts "z = " + z.ring.toScript();
    end
    if p == 0
      raise ArgumentError, "No finite ring."
    end
    if n == 0
      raise ArgumentError, "No finite ring."
    end
    field = true;
    if !PrimeInteger.isPrime(p)
      field = false;
      #raise ArgumentError, "{p} not prime."
    end
    mf = $finiteFields[ [p,n] ];
    if mf == nil 
       cf = GF(p).ring;
       mf = PolyUfdUtil.algebraicNumberField(cf,n);
       $finiteFields[ [p,n] ] = mf;
       #puts "mf = " + mf.toScript();
    end
    if z == 0
        r = AlgebraicNumber.new(mf);
    else
        r = AlgebraicNumber.new(mf,z);
        #puts "r = " + r.toScript();
    end
    return RingElem.new(r);
end


java_import "edu.jas.root.RealRootsSturm";
java_import "edu.jas.root.Interval";
java_import "edu.jas.root.RealAlgebraicNumber";
java_import "edu.jas.root.RealAlgebraicRing";
java_import "edu.jas.root.ComplexRootsSturm";
java_import "edu.jas.root.Rectangle";
java_import "edu.jas.root.RootFactory";

java_import "edu.jas.application.AlgebraicRootsPrimElem";
java_import "edu.jas.application.RootFactoryApp";


=begin rdoc
Create JAS RealAlgebraicNumber as ring element.
=end
def RealN(m,i,r=0)
    if m.is_a? RingElem
        m = m.elem;
    end
    if r.is_a? RingElem
        r = r.elem;
    end
    if i.is_a? Array
        il = BigRational.new(i[0]);
        ir = BigRational.new(i[1]);
        i = Interval.new(il,ir);
    end
    #puts "m.getClass() = " + m.getClass().getName().to_s;
    if m.is_a? RealAlgebraicNumber
        mf = RealAlgebraicRing.new(m.factory().algebraic.modul,i);
    else
        mf = RealAlgebraicRing.new(m,i);
    end
    if r == 0
        rr = RealAlgebraicNumber.new(mf);
    else
        rr = RealAlgebraicNumber.new(mf,r);
    end
    return RingElem.new(rr);
end


java_import "edu.jas.ufd.Quotient";
java_import "edu.jas.ufd.QuotientRing";
java_import "edu.jas.fd.SolvableQuotient";
java_import "edu.jas.fd.SolvableQuotientRing";
java_import "edu.jas.fd.QuotSolvablePolynomial";
java_import "edu.jas.fd.QuotSolvablePolynomialRing";
java_import "edu.jas.application.ResidueSolvablePolynomial";
java_import "edu.jas.application.ResidueSolvablePolynomialRing";
java_import "edu.jas.application.LocalSolvablePolynomial";
java_import "edu.jas.application.LocalSolvablePolynomialRing";
java_import "edu.jas.application.ResidueSolvableWordPolynomial";
java_import "edu.jas.application.ResidueSolvableWordPolynomialRing";


=begin rdoc
Create JAS rational function Quotient as ring element.
=end
def RF(pr,d=0,n=1)
    if d.is_a? Array
        if n != 1
            puts "#{} ignored\n";
        end
        if d.size > 1
            n = d[1];
        end
        d = d[0];
    end
    if d.is_a? RingElem
        d = d.elem;
    end
    if n.is_a? RingElem
        n = n.elem;
    end
    if pr.is_a? RingElem
        pr = pr.elem;
    end
    if pr.is_a? Ring
        pr = pr.ring;
    end
    qr = QuotientRing.new(pr);
    if d == 0
        r = Quotient.new(qr);
    else
        if n == 1
            r = Quotient.new(qr,d);
        else
            r = Quotient.new(qr,d,n);
        end
    end
    return RingElem.new(r);
end


=begin rdoc
Create JAS rational function SolvableQuotient as ring element.
=end
def SRF(pr,d=0,n=1)
    if d.is_a? Array
        if n != 1
            puts "#{} ignored\n";
        end
        if d.size > 1
            n = d[1];
        end
        d = d[0];
    end
    if d.is_a? RingElem
        d = d.elem;
    end
    if n.is_a? RingElem
        n = n.elem;
    end
    if pr.is_a? RingElem
        pr = pr.elem;
    end
    if pr.is_a? Ring
        pr = pr.ring;
    end
    qr = SolvableQuotientRing.new(pr);
    #puts "qr is associative: " + qr.isAssociative().to_s;
    #if not qr.isAssociative()
    #   puts "warning: qr is not associative";
    #end
    if d == 0
        r = SolvableQuotient.new(qr);
    else
        if n == 1
            r = SolvableQuotient.new(qr,d);
        else
            r = SolvableQuotient.new(qr,d,n);
        end
    end
    return RingElem.new(r);
end


java_import "edu.jas.application.PolyUtilApp";
java_import "edu.jas.application.Residue";
java_import "edu.jas.application.ResidueRing";
java_import "edu.jas.application.Ideal";
java_import "edu.jas.application.SolvableResidue";
java_import "edu.jas.application.SolvableResidueRing";
java_import "edu.jas.application.SolvableIdeal";
java_import "edu.jas.application.Local";
java_import "edu.jas.application.LocalRing";
java_import "edu.jas.application.SolvableLocal";
java_import "edu.jas.application.SolvableLocalRing";
java_import "edu.jas.application.SolvableLocalResidue";
java_import "edu.jas.application.SolvableLocalResidueRing";
java_import "edu.jas.application.IdealWithRealAlgebraicRoots";
java_import "edu.jas.application.ComprehensiveGroebnerBaseSeq";
java_import "edu.jas.application.WordIdeal";
java_import "edu.jas.application.WordResidue";
java_import "edu.jas.application.WordResidueRing";


=begin rdoc
Create JAS polynomial Residue as ring element.
=end
def RC(ideal,r=0)
    if ideal == nil
        raise ArgumentError, "No ideal given."
    end
    if ideal.is_a? SimIdeal
        #puts "ideal.pset = " + str(ideal.pset) + "\n";
        #ideal = Java::EduJasApplication::Ideal.new(ideal.ring,ideal.list);
        ideal = Ideal.new(ideal.pset);
        #ideal.doGB();
    end
    #puts "ideal.getList().get(0).ring.ideal = #{ideal.getList().get(0).ring.ideal}\n";
    if ideal.getList().get(0).ring.is_a? ResidueRing
        rc = ResidueRing.new( ideal.getList().get(0).ring.ideal );
    else
        rc = ResidueRing.new(ideal);
    end
    if r.is_a? RingElem
        r = r.elem;
    end
    if r == 0
        r = Residue.new(rc);
    else
        r = Residue.new(rc,r);
    end
    return RingElem.new(r);
end


=begin rdoc
Create JAS polynomial Local as ring element.
=end
def LC(ideal,d=0,n=1)
    if ideal == nil
        raise ArgumentError, "No ideal given."
    end
    if ideal.is_a? SimIdeal
        ideal = Ideal.new(ideal.pset);
        #ideal.doGB();
    end
    #puts "ideal.getList().get(0).ring.ideal = #{ideal.getList().get(0).ring.ideal}\n";
    if ideal.getList().get(0).ring.is_a? LocalRing
        lc = LocalRing.new( ideal.getList().get(0).ring.ideal );
    else
        lc = LocalRing.new(ideal);
    end
    if d.is_a? Array
        if n != 1
            puts "#{n} ignored\n";
        end
        if d.size > 1
            n = d[1];
        end
        d = d[0];
    end
    if d.is_a? RingElem
        d = d.elem;
    end
    if n.is_a? RingElem
        n = n.elem;
    end
    if d == 0
        r = Local.new(lc);
    else
        if n == 1
            r = Local.new(lc,d);
        else
            r = Local.new(lc,d,n);
        end
    end
    return RingElem.new(r);
end


=begin rdoc
Create JAS polynomial SolvableResidue as ring element.
=end
def SRC(ideal,r=0)
    if ideal == nil
        raise ArgumentError, "No ideal given."
    end
    if ideal.is_a? SolvIdeal
        #puts "ideal.pset = " + str(ideal.pset) + "\n";
        #ideal = Java::EduJasApplication::Ideal.new(ideal.ring,ideal.list);
        ideal = SolvableIdeal.new(ideal.pset);
        #ideal.doGB();
    end
    #puts "ideal.getList().get(0).ring.ideal = #{ideal.getList().get(0).ring.ideal}\n";
    if ideal.getList().get(0).ring.is_a? SolvableResidueRing
        rc = SolvableResidueRing.new( ideal.getList().get(0).ring.ideal );
    else
        rc = SolvableResidueRing.new(ideal);
    end
    if r.is_a? RingElem
        r = r.elem;
    end
    if r == 0
        r = SolvableResidue.new(rc);
    else
        r = SolvableResidue.new(rc,r);
    end
    return RingElem.new(r);
end


=begin rdoc
Create JAS polynomial SolvableLocal as ring element.
=end
def SLC(ideal,d=0,n=1)
    if ideal == nil
        raise ArgumentError, "No ideal given."
    end
    if ideal.is_a? SolvIdeal
        ideal = SolvableIdeal.new(ideal.pset);
        #ideal.doGB();
    end
    #puts "ideal.getList().get(0).ring.ideal = #{ideal.getList().get(0).ring.ideal}\n";
    if ideal.getList().get(0).ring.is_a? SolvableLocalRing
        lc = SolvableLocalRing.new( ideal.getList().get(0).ring.ideal );
    else
        lc = SolvableLocalRing.new(ideal);
    end
    if d.is_a? Array
        if n != 1
            puts "#{n} ignored\n";
        end
        if d.size > 1
            n = d[1];
        end
        d = d[0];
    end
    if d.is_a? RingElem
        d = d.elem;
    end
    if n.is_a? RingElem
        n = n.elem;
    end
    if d == 0
        r = SolvableLocal.new(lc);
    else
        if n == 1
            r = SolvableLocal.new(lc,d);
        else
            r = SolvableLocal.new(lc,d,n);
        end
    end
    return RingElem.new(r);
end


=begin rdoc
Create JAS polynomial SolvableLocalResidue as ring element.
=end
def SLR(ideal,d=0,n=1)
    if ideal == nil
        raise ArgumentError, "No ideal given."
    end
    if ideal.is_a? SolvIdeal
        ideal = SolvableIdeal.new(ideal.pset);
        #ideal.doGB();
    end
    cfr = ideal.getList().get(0).ring;
    #puts "ideal.getList().get(0).ring.ideal = #{ideal.getList().get(0).ring.ideal}\n";
    if n == true
       isfield = true;
       n = 1;
    end
    if cfr.is_a? SolvableLocalResidueRing
        lc = SolvableLocalResidueRing.new( cfr.ideal );
    else
        lc = SolvableLocalResidueRing.new(ideal);
    end
    if d.is_a? Array
        if n != 1
            puts "#{n} ignored\n";
        end
        if d.size > 1
            n = d[1];
        end
        d = d[0];
    end
    if d.is_a? RingElem
        d = d.elem;
    end
    if n.is_a? RingElem
        n = n.elem;
    end
    if d == 0
        r = SolvableLocalResidue.new(lc);
    else
        if n == 1
            r = SolvableLocalResidue.new(lc,d);
        else
            r = SolvableLocalResidue.new(lc,d,n);
        end
    end
    return RingElem.new(r);
end


=begin rdoc
Create JAS regular ring Product as ring element.
=end
def RR(flist,n=1,r=0)
    if not n.is_a? Integer
        r = n;
        n = 1;
    end
    if flist == nil
        raise ArgumentError, "No list given."
    end
    if flist.is_a? Array
        flist = rbarray2arraylist( flist.map { |x| x.factory() }, rec=1);
        ncop = 0;
    else
        ncop = n;
    end
    if flist.is_a? RingElem
        flist = flist.elem;
        flist = flist.factory();
        ncop = n;
    end
    #puts "flist = " + str(flist);
    #puts "ncop  = " + str(ncop);
    if ncop == 0
        pr = ProductRing.new(flist);
    else
        pr = ProductRing.new(flist,ncop);
    end
    #puts "r type(#{r}) = #{r.class}\n";
    if r.is_a? RingElem
        r = r.elem;
    end
    begin
        #puts "r.class() = #{r.class}\n";
        if r.is_a? Product
            #puts "r.val = #{r.val}\n";
            r = r.val;
        end
    rescue
        #pass;
    end
    #puts "r = " + r.to_s;
    if r == 0
        r = Product.new(pr);
    else
        r = Product.new(pr,r);
    end
    return RingElem.new(r);
end


=begin rdoc
Convert a Ruby array to a Java ArrayList.

If list is a Ruby array, it is converted, else list is left unchanged.
=end
def rbarray2arraylist(list,fac=nil,rec=1)
    #puts "list type(#{list}) = #{list.class}\n";
    if list.is_a? Array
       ll = ArrayList.new();
       for e in list
           t = true;
           if e.is_a? RingElem
               t = false;
               e = e.elem;
           end
           if e.is_a? Array
               if rec <= 1
                   e = makeJasArith(e);
               else
                   t = false;
                   e = rbarray2arraylist(e,fac,rec-1);
               end
           end
           begin
               #n = e.getClass().getSimpleName();
               if e.is_a? ArrayList
                   t = false;
               end
           rescue
               #pass;
           end
           if t and fac != nil
               #puts "e.p(#{e}) = #{e.class}\n";
               e = fac.parse( str(e) ); #or makeJasArith(e) ?
           end
           ll.add(e);
       end
       list = ll;
    end
    #puts "list type(#{list}) = #{list.class}\n";
    return list
end


=begin rdoc
Construct a jas.arith object.

If item is an ruby array then a BigComplex is constructed. 
If item is a ruby float then a BigDecimal is constructed. 
=end
def makeJasArith(item)
    #puts "item type(#{item}) = #{item.class}\n";
    if item.is_a? Integer
        return BigInteger.new( item );
    end
    if item.is_a? Rational
        return BigRational.new( item.numerator ).divide( BigRational.new( item.denominator ) );
    end
    if item.is_a? Float  # ?? what to do ??
        return BigDecimal.new( item.to_s );
    end
    if item.is_a? Array
        if item.size > 2
            puts "len(item) > 2, remaining items ignored\n";
        end
        puts "item[0] type(#{item[0]}) = #{item[0].class}\n";
        if item.size > 1
            re = makeJasArith( item[0] );
            if not re.isField()
                re = BigRational.new( re.val );
            end
            im = makeJasArith( item[1] );
            if not im.isField()
                im = BigRational.new( im.val );
            end
            jasArith = BigComplex.new( re, im );
        else
            re = makeJasArith( item[0] );
            if not re.isField()
                re = BigRational.new( re.val );
            end
            jasArith = BigComplex.new( re );
        end
        return jasArith;
    end
    puts "unknown item type(#{item}) = #{item.class}\n";
    return item;
end


java_import "edu.jas.gb.DGroebnerBaseSeq";
java_import "edu.jas.gb.EGroebnerBaseSeq";
java_import "edu.jas.gb.EReductionSeq";
java_import "edu.jas.gb.GroebnerBaseDistributedEC";
java_import "edu.jas.gb.GroebnerBaseDistributedHybridEC";
#java_import "edu.jas.gb.GBDist";
java_import "edu.jas.gb.GroebnerBaseParallel";
java_import "edu.jas.gb.GroebnerBaseSeq";
java_import "edu.jas.gb.GroebnerBaseSeqIter";
java_import "edu.jas.gb.GroebnerBaseSeqPairSeq";
java_import "edu.jas.gb.ReductionSeq";
java_import "edu.jas.gb.OrderedPairlist";
java_import "edu.jas.gb.OrderedSyzPairlist";
java_import "edu.jas.gb.GroebnerBaseSeqPairParallel";
java_import "edu.jas.gb.SolvableGroebnerBaseParallel";
java_import "edu.jas.gb.SolvableGroebnerBaseSeq";
java_import "edu.jas.gb.SolvableReductionSeq";
java_import "edu.jas.gb.WordGroebnerBaseSeq";

java_import "edu.jas.gbufd.GroebnerBasePseudoRecSeq";
java_import "edu.jas.gbufd.GroebnerBasePseudoSeq";
java_import "edu.jas.gbufd.SolvableGroebnerBasePseudoRecSeq";
java_import "edu.jas.gbufd.SolvableGroebnerBasePseudoSeq";
java_import "edu.jas.gbufd.WordGroebnerBasePseudoSeq";
java_import "edu.jas.gbufd.WordGroebnerBasePseudoRecSeq";
java_import "edu.jas.gbufd.RGroebnerBasePseudoSeq";
java_import "edu.jas.gbufd.GroebnerBasePseudoParallel";
java_import "edu.jas.gbufd.PseudoReductionSeq";
java_import "edu.jas.gbufd.RGroebnerBaseSeq";
java_import "edu.jas.gbufd.RReductionSeq";
java_import "edu.jas.gbufd.CharacteristicSetWu";
java_import "edu.jas.gbufd.GroebnerBaseFGLM";
java_import "edu.jas.gbufd.GroebnerBaseWalk";

java_import "edu.jas.gbufd.SyzygySeq";
java_import "edu.jas.gbufd.SolvableSyzygySeq";


=begin rdoc
Represents a JAS polynomial ideal: PolynomialList and Ideal.

Methods for Groebner bases, ideal sum, intersection and others.
=end
class SimIdeal
    include Comparable
    # the Java polynomial list, polynomial ring, and ideal decompositions
    attr_reader :pset, :ring, :list, :roots, :prime, :primary #, :ideal

=begin rdoc
SimIdeal constructor.
=end
    def initialize(ring,polystr="",list=nil)
        @ring = ring;
        if list == nil
           sr = StringReader.new( polystr );
           tok = GenPolynomialTokenizer.new(ring::ring,sr);
           @list = tok.nextPolynomialList();
        else
           @list = rbarray2arraylist(list,rec=1);
        end
        #@list = PolyUtil.monic(@list);
        @pset = OrderedPolynomialList.new(@ring.ring,@list);
        #@ideal = Ideal.new(@pset);
        @roots = nil;
        @croots = nil;
        @prime = nil;
        @primary = nil;
        #super(@ring::ring,@list) # non-sense, JRuby extends application.Ideal
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @pset.toScript();
    end

=begin rdoc
Compare two ideals.
=end
    def <=>(other)
        s = Ideal.new(@pset);
        o = Ideal.new(other.pset);
        return s.compareTo(o);
    end

=begin rdoc
Test if two ideals are equal.
=end
    def ==(other)
        if not other.is_a? SimIdeal
           return false;
        end
        return (self <=> other) == 0; 
    end

=begin rdoc
Test if ideal is one.
=end
    def isONE()
        s = Ideal.new(@pset);
        return s.isONE(); 
    end

=begin rdoc
Test if ideal is zero.
=end
    def isZERO()
        s = Ideal.new(@pset);
        return s.isZERO(); 
    end

=begin rdoc
Create an ideal in a polynomial ring with parameter coefficients.
=end
    def paramideal()
        return ParamIdeal.new(@ring,"",@list);
    end

=begin rdoc
Compute a Groebner base.
=end
    def GB()
        #if @ideal != nil
        #   return SimIdeal.new(@ring,"",nil,@ideal.GB());
        #end
        cofac = @ring.ring.coFac;
        ff = @pset.list;
        kind = "";
        t = System.currentTimeMillis();
        if cofac.isField()
            #gg = GroebnerBaseSeq.new().GB(ff);
            #gg = GroebnerBaseSeq.new(ReductionSeq.new(),OrderedPairlist.new()).GB(ff);
            gg = GroebnerBaseSeq.new(ReductionSeq.new(),OrderedSyzPairlist.new()).GB(ff);
            #gg = GroebnerBaseSeqIter.new(ReductionSeq.new(),OrderedSyzPairlist.new()).GB(ff);
            kind = "field"
        else
            if cofac.is_a? GenPolynomialRing and cofac.isCommutative()
                gg = GroebnerBasePseudoRecSeq.new(cofac).GB(ff);
                kind = "pseudoRec"
            else
                gg = GroebnerBasePseudoSeq.new(cofac).GB(ff);
                kind = "pseudo"
            end
        end
        t = System.currentTimeMillis() - t;
        puts "sequential(#{kind}) GB executed in #{t} ms\n"; 
        return SimIdeal.new(@ring,"",gg);
    end

=begin rdoc
Test if this is a Groebner base.
=end
    def isGB()
        s = @pset;
        cofac = s.ring.coFac;
        ff = s.list;
        t = System.currentTimeMillis();
        if cofac.isField()
            b = GroebnerBaseSeq.new().isGB(ff);
        else
            if cofac.is_a? GenPolynomialRing and cofac.isCommutative()
                b = GroebnerBasePseudoRecSeq.new(cofac).isGB(ff);
            else
                b = GroebnerBasePseudoSeq.new(cofac).isGB(ff);
            end
        end
        t = System.currentTimeMillis() - t;
        puts "isGB = #{b} executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Compute an e-Groebner base.
=end
    def eGB()
        s = @pset;
        cofac = s.ring.coFac;
        ff = s.list;
        t = System.currentTimeMillis();
        if cofac.isField()
            gg = GroebnerBaseSeq.new().GB(ff);
        else
            gg = EGroebnerBaseSeq.new().GB(ff)
        end
        t = System.currentTimeMillis() - t;
        puts "sequential e-GB executed in #{t} ms\n"; 
        return SimIdeal.new(@ring,"",gg);
    end

=begin rdoc
Test if this is an e-Groebner base.
=end
    def iseGB()
        s = @pset;
        cofac = s.ring.coFac;
        ff = s.list;
        t = System.currentTimeMillis();
        if cofac.isField()
            b = GroebnerBaseSeq.new().isGB(ff);
        else
            b = EGroebnerBaseSeq.new().isGB(ff)
        end
        t = System.currentTimeMillis() - t;
        puts "is e-GB = #{b} executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Compute an d-Groebner base.
=end
    def dGB()
        s = @pset;
        cofac = s.ring.coFac;
        ff = s.list;
        t = System.currentTimeMillis();
        if cofac.isField()
            gg = GroebnerBaseSeq.new().GB(ff);
        else
            gg = DGroebnerBaseSeq.new().GB(ff)
        end
        t = System.currentTimeMillis() - t;
        puts "sequential d-GB executed in #{t} ms\n"; 
        return SimIdeal.new(@ring,"",gg);
    end

=begin rdoc
Test if this is a d-Groebner base.
=end
    def isdGB()
        s = @pset;
        cofac = s.ring.coFac;
        ff = s.list;
        t = System.currentTimeMillis();
        if cofac.isField()
            b = GroebnerBaseSeq.new().isGB(ff);
        else
            b = DGroebnerBaseSeq.new().isGB(ff)
        end
        t = System.currentTimeMillis() - t;
        puts "is d-GB = #{b} executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Compute in parallel a Groebner base.
=end
    def parUnusedGB(th)
        s = @pset;
        ff = s.list;
        bbpar = GroebnerBaseSeqPairParallel.new(th);
        t = System.currentTimeMillis();
        gg = bbpar.GB(ff);
        t = System.currentTimeMillis() - t;
        bbpar.terminate();
        puts "parallel-old #{th} executed in #{t} ms\n"; 
        return SimIdeal.new(@ring,"",gg);
    end

=begin rdoc
Compute in parallel a Groebner base.
=end
    def parGB(th)
        s = @pset;
        ff = s.list;
        cofac = s.ring.coFac;
        if cofac.isField() 
           bbpar = GroebnerBaseParallel.new(th);
        else 
           bbpar = GroebnerBasePseudoParallel.new(th,cofac);
        end
        t = System.currentTimeMillis();
        gg = bbpar.GB(ff);
        t = System.currentTimeMillis() - t;
        bbpar.terminate();
        puts "parallel #{th} executed in #{t} ms\n"; 
        return SimIdeal.new(@ring,"",gg);
    end

=begin rdoc
Compute on a distributed system a Groebner base.
=end
    def distGB(th=2,machine="examples/machines.localhost",port=55711)
        s = @pset;
        ff = s.list;
        t = System.currentTimeMillis();
        # old: gbd = GBDist.new(th,machine,port);
        gbd = GroebnerBaseDistributedEC.new(machine,th,port);
        #gbd = GroebnerBaseDistributedHybridEC.new(machine,th,3,port);
        t1 = System.currentTimeMillis();
        gg = gbd.GB(ff);
        t1 = System.currentTimeMillis() - t1;
        gbd.terminate(false);
        t = System.currentTimeMillis() - t;
        puts "distributed #{th} executed in #{t1} ms (#{t-t1} ms start-up)\n"; 
        return SimIdeal.new(@ring,"",gg);
    end

=begin rdoc
Client for a distributed computation.
=end
    def distClient(port=4711)
        s = @pset;
        e1 = ExecutableServer.new( port );
        e1.init();
        e2 = ExecutableServer.new( port+1 );
        e2.init();
        @exers = [e1,e2];
        return nil;
    end


=begin rdoc
Client for a distributed computation.
=end
    def distClientStop()
        for es in @exers;
            es.terminate();
        end
        return nil;
    end

=begin rdoc
Compute a normal form of p with respect to this ideal.
=end
    def reduction(p)
        s = @pset;
        gg = s.list;
        if p.is_a? RingElem
            p = p.elem;
        end
        #t = System.currentTimeMillis();
        if @ring.ring.coFac.isField()
           n = ReductionSeq.new().normalform(gg,p);
        else 
           n = PseudoReductionSeq.new().normalform(gg,p);
           #ff = PseudoReductionSeq.New().normalformFactor(gg,p);
           #print "ff.multiplicator = " + str(ff.multiplicator)
        end
        #t = System.currentTimeMillis() - t;
        #puts "sequential reduction executed in " + str(t) + " ms"; 
        return RingElem.new(n);
    end

=begin rdoc
Compute a e-normal form of p with respect to this ideal.
=end
    def eReduction(p)
        s = @pset;
        gg = s.list;
        if p.is_a? RingElem
            p = p.elem;
        end
        t = System.currentTimeMillis();
        n = EReductionSeq.new().normalform(gg,p);
        t = System.currentTimeMillis() - t;
        puts "sequential eReduction executed in " + str(t) + " ms"; 
        return RingElem.new(n);
    end

=begin rdoc
Compute a normal form of this ideal with respect to reducer.
=end
    def NF(reducer)
        s = @pset;
        ff = s.list;
        gg = reducer.list;
        t = System.currentTimeMillis();
        nn = ReductionSeq.new().normalform(gg,ff);
        t = System.currentTimeMillis() - t;
        puts "sequential NF executed in #{t} ms\n"; 
        return SimIdeal.new(@ring,"",nn);
    end

=begin rdoc
Represent p as element of this ideal.
=end
    def lift(p)
        gg = @pset.list;
        z = @ring.ring.getZERO();
        rr = gg.map { |x| z };
        if p.is_a? RingElem
            p = p.elem;
        end
        #t = System.currentTimeMillis();
        if @ring.ring.coFac.isField()
           n = ReductionSeq.new().normalform(rr,gg,p);
        else 
           n = PseudoReductionSeq.new().normalform(rr,gg,p);
        end
        if not n.isZERO()
           raise StandardError, "p ist not a member of the ideal"
        end
        #t = System.currentTimeMillis() - t;
        #puts "sequential reduction executed in " + str(t) + " ms"; 
        return rr.map { |x| RingElem.new(x) };
    end

=begin rdoc
Compute a interreduced ideal basis of this.
=end
    def interreduced_basis()
        ff = @pset.list;
        nn = ReductionSeq.new().irreducibleSet(ff);
        return nn.map{ |x| RingElem.new(x) };
    end

=begin rdoc
Compute the intersection of this and the given polynomial ring.
=end
    def intersectRing(ring)
        s = Ideal.new(@pset);
        nn = s.intersect(ring.ring);
        return SimIdeal.new(ring,"",nn.getList());
    end

=begin rdoc
Compute the intersection of this and the given ideal.
=end
    def intersect(id2)
        s1 = Ideal.new(@pset);
        s2 = Ideal.new(id2.pset);
        nn = s1.intersect(s2);
        return SimIdeal.new(@ring,"",nn.getList());
    end

=begin rdoc
Compute the elimination ideal of this and the given polynomial ring.
=end
    def eliminateRing(ring)
        s = Ideal.new(@pset);
        nn = s.eliminate(ring.ring);
        r = Ring.new( "", nn.getRing() );
        return SimIdeal.new(r,"",nn.getList());
    end

=begin rdoc
Compute the saturation of this and the given ideal.
=end
    def sat(id2)
        s1 = Ideal.new(@pset);
        s2 = Ideal.new(id2.pset);
        #nn = s1.infiniteQuotient(s2);
        nn = s1.infiniteQuotientRab(s2);
        mm = nn.getList(); #PolyUtil.monicRec(nn.getList());
        return SimIdeal.new(@ring,"",mm);
    end

=begin rdoc
Compute the sum of this and the ideal.
=end
    def sum(other)
        s = Ideal.new(@pset);
        t = Ideal.new(other.pset);
        nn = s.sum( t );
        return SimIdeal.new(@ring,"",nn.getList());
    end

=begin rdoc
Compute the univariate polynomials in each variable of this ideal.
=end
    def univariates()
        s = Ideal.new(@pset);
        ll = s.constructUnivariate();
        nn = ll.map {|e| RingElem.new(e) };
        return nn;
    end

=begin rdoc
Compute the inverse polynomial modulo this ideal, if it exists.
=end
    def inverse(p)
        if p.is_a? RingElem
            p = p.elem;
        end
        s = Ideal.new(@pset);
        i = s.inverse(p);
        return RingElem.new(i);
    end

=begin rdoc
Optimize the term order on the variables.
=end
    def optimize()
        p = @pset;
        o = TermOrderOptimization.optimizeTermOrder(p);
        r = Ring.new("",o.ring);
        return SimIdeal.new(r,"",o.list);
    end

=begin rdoc
Compute real roots of 0-dim ideal.
=end
    def realRoots()
        ii = Ideal.new(@pset);
        @roots = PolyUtilApp.realAlgebraicRoots(ii);
        for r in @roots
            r.doDecimalApproximation();
        end
        return @roots;
    end

=begin rdoc
Print decimal approximation of real roots of 0-dim ideal.
=end
    def realRootsPrint()
        if @roots == nil
            ii = Ideal.new(@pset);
            @roots = PolyUtilApp.realAlgebraicRoots(ii);
            for r in @roots
                r.doDecimalApproximation();
            end
        end
        for ir in @roots
            for dr in ir.decimalApproximation()
                puts dr.to_s;
            end
            puts;
        end
    end

=begin rdoc
Compute radical decomposition of this ideal.
=end
    def radicalDecomp()
        ii = Ideal.new(@pset);
        @radical = ii.radicalDecomposition();
        return @radical;
    end

=begin rdoc
Compute irreducible decomposition of this ideal.
=end
    def decomposition()
        ii = Ideal.new(@pset);
        @irrdec = ii.decomposition();
        return @irrdec;
    end

=begin rdoc
Compute complex roots of 0-dim ideal.
=end
    def complexRoots()
        ii = Ideal.new(@pset);
        @croots = PolyUtilApp.complexAlgebraicRoots(ii);
        for r in @croots
            r.doDecimalApproximation();
        end
        return @croots;
    end

=begin rdoc
Print decimal approximation of complex roots of 0-dim ideal.
=end
    def complexRootsPrint()
        if @croots == nil
            ii = Ideal.new(@pset);
            @croots = PolyUtilApp.complexAlgebraicRoots(ii);
            for r in @croots
                r.doDecimalApproximation();
            end
        end
        for ic in @croots
            for dc in ic.decimalApproximation()
                puts dc.to_s;
            end
            puts;
        end
    end

=begin rdoc
Compute prime decomposition of this ideal.
=end
    def primeDecomp()
        ii = Ideal.new(@pset);
        @prime = ii.primeDecomposition();
        return @prime;
    end

=begin rdoc
Compute primary decomposition of this ideal.
=end
    def primaryDecomp()
        ii = Ideal.new(@pset);
##         if @prime == nil:
##             @prime = I.primeDecomposition();
        @primary = ii.primaryDecomposition();
        return @primary;
    end

=begin rdoc
Convert rational coefficients to integer coefficients.
=end
    def toInteger()
        p = @pset;
        l = p.list;
        r = p.ring;
        ri = GenPolynomialRing.new( BigInteger.new(), r.nvar, r.tord, r.vars );
        pi = PolyUtil.integerFromRationalCoefficients(ri,l);
        r = Ring.new("",ri);
        return SimIdeal.new(r,"",pi);
    end

=begin rdoc
Convert integer coefficients to modular coefficients.
=end
    def toModular(mf)
        p = @pset;
        l = p.list;
        r = p.ring;
        if mf.is_a? RingElem
            mf = mf.ring;
        end
        rm = GenPolynomialRing.new( mf, r.nvar, r.tord, r.vars );
        pm = PolyUtil.fromIntegerCoefficients(rm,l);
        r = Ring.new("",rm);
        return SimIdeal.new(r,"",pm);
    end

=begin rdoc
Compute a Characteristic Set.
=end
    def CS()
        s = @pset;
        cofac = s.ring.coFac;
        ff = s.list;
        t = System.currentTimeMillis();
        if cofac.isField()
            gg = CharacteristicSetWu.new().characteristicSet(ff);
        else
            puts "CS not implemented for coefficients #{cofac.toScriptFactory()}\n"; 
            gg = nil;
        end
        t = System.currentTimeMillis() - t;
        puts "sequential char set executed in #{t} ms\n"; 
        return SimIdeal.new(@ring,"",gg);
    end

=begin rdoc
Test for Characteristic Set.
=end
    def isCS()
        s = @pset;
        cofac = s.ring.coFac;
        ff = s.list.clone();
        Collections.reverse(ff); # todo
        t = System.currentTimeMillis();
        if cofac.isField()
            b = CharacteristicSetWu.new().isCharacteristicSet(ff);
        else
            puts "isCS not implemented for coefficients #{cofac.toScriptFactory()}\n"; 
            b = false;
        end
        t = System.currentTimeMillis() - t;
        #puts "sequential is char set executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Compute a normal form of polynomial p with respect this characteristic set.
=end
    def csReduction(p)
        s = @pset;
        ff = s.list.clone();
        Collections.reverse(ff); # todo
        if p.is_a? RingElem
            p = p.elem;
        end
        t = System.currentTimeMillis();
        nn = CharacteristicSetWu.new().characteristicSetReduction(ff,p);
        t = System.currentTimeMillis() - t;
        #puts "sequential char set reduction executed in #{t} ms\n"; 
        return RingElem.new(nn);
    end

=begin rdoc
Syzygy of generating polynomials.
=end
    def syzygy()
        p = @pset;
        l = p.list;
        t = System.currentTimeMillis();
        s = SyzygySeq.new(p.ring.coFac).zeroRelations( l );
        t = System.currentTimeMillis() - t;
        puts "executed Syzygy in #{t} ms\n"; 
        m = CommutativeModule.new("",p.ring);
        return SubModule.new(m,"",s);
    end

=begin rdoc
Test if this is a syzygy of the module in m.
=end
    def isSyzygy(m)
        p = @pset;
        g = p.list;
        l = m.list;
        #puts "l = #{l}"; 
        #puts "g = #{g}"; 
        t = System.currentTimeMillis();
        z = SyzygySeq.new(p.ring.coFac).isZeroRelation( l, g );
        t = System.currentTimeMillis() - t;
        puts "executed isSyzygy in #{t} ms\n"; 
        return z;
    end

end


=begin rdoc
Represents a JAS polynomial ideal with polynomial coefficients.

Methods to compute comprehensive Groebner bases.
=end
class ParamIdeal

=begin rdoc
Parametric ideal constructor.
=end
    def initialize(ring,polystr="",list=nil,gbsys=nil)
        @ring = ring;
        if list == nil and polystr != nil
           sr = StringReader.new( polystr );
           tok = GenPolynomialTokenizer.new(ring.ring,sr);
           @list = tok.nextPolynomialList();
        else
           @list = rbarray2arraylist(list,rec=1);
        end
        @gbsys = gbsys;
        @pset = OrderedPolynomialList.new(ring.ring,@list);
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        if @gbsys == nil
            return @pset.toScript();
        else
            return @pset.toScript() + "\n" + @gbsys.toScript();
#            return @pset.toScript() + "\n" + @gbsys.to_s;
        end
    end

=begin rdoc
Optimize the term order on the variables of the coefficients.
=end
    def optimizeCoeff()
        p = @pset;
        o = TermOrderOptimization.optimizeTermOrderOnCoefficients(p);
        r = Ring.new("",o.ring);
        return ParamIdeal.new(r,"",o.list);
    end

=begin rdoc
Optimize the term order on the variables of the quotient coefficients.
=end
    def optimizeCoeffQuot()
        p = @pset;
        l = p.list;
        r = p.ring;
        q = r.coFac;
        c = q.ring;
        rc = GenPolynomialRing.new( c, r.nvar, r.tord, r.vars );
        #puts "rc = ", rc;        
        lp = PolyUfdUtil.integralFromQuotientCoefficients(rc,l);
        #puts "lp = ", lp;
        pp = PolynomialList.new(rc,lp);
        #puts "pp = ", pp;        
        oq = TermOrderOptimization.optimizeTermOrderOnCoefficients(pp);
        oor = oq.ring;
        qo = oor.coFac;
        cq = QuotientRing.new( qo );
        rq = GenPolynomialRing.new( cq, r.nvar, r.tord, r.vars );
        #puts "rq = ", rq;        
        o = PolyUfdUtil.quotientFromIntegralCoefficients(rq,oq.list);
        r = Ring.new("",rq);
        return ParamIdeal.new(r,"",o);
    end

=begin rdoc
Convert rational function coefficients to integral function coefficients.
=end
    def toIntegralCoeff()
        p = @pset;
        l = p.list;
        r = p.ring;
        q = r.coFac;
        c = q.ring;
        rc = GenPolynomialRing.new( c, r.nvar, r.tord, r.vars );
        #puts "rc = ", rc;        
        lp = PolyUfdUtil.integralFromQuotientCoefficients(rc,l);
        #puts "lp = ", lp;
        r = Ring.new("",rc);
        return ParamIdeal.new(r,"",lp);
    end

=begin rdoc
Convert integral function coefficients to modular function coefficients.
=end
    def toModularCoeff(mf)
        p = @pset;
        l = p.list;
        r = p.ring;
        c = r.coFac;
        #puts "c = ", c;
        if mf.is_a? RingElem
            mf = mf.ring;
        end
        cm = GenPolynomialRing.new( mf, c.nvar, c.tord, c.vars );
        #puts "cm = ", cm;
        rm = GenPolynomialRing.new( cm, r.nvar, r.tord, r.vars );
        #puts "rm = ", rm;
        pm = PolyUfdUtil.fromIntegerCoefficients(rm,l);
        r = Ring.new("",rm);
        return ParamIdeal.new(r,"",pm);
    end

=begin rdoc
Convert integral function coefficients to rational function coefficients.
=end
    def toQuotientCoeff()
        p = @pset;
        l = p.list;
        r = p.ring;
        c = r.coFac;
        #puts "c = ", c;
        q = QuotientRing.new(c);
        #puts "q = ", q;
        qm = GenPolynomialRing.new( q, r.nvar, r.tord, r.vars );
        #puts "qm = ", qm;
        pm = PolyUfdUtil.quotientFromIntegralCoefficients(qm,l);
        r = Ring.new("",qm);
        return ParamIdeal.new(r,"",pm);
    end

=begin rdoc
Compute a Groebner base.
=end
    def GB()
        ii = SimIdeal.new(@ring,"",@pset.list);
        g = ii.GB();
        return ParamIdeal.new(g.ring,"",g.pset.list);
    end

=begin rdoc
Test if this is a Groebner base.
=end
    def isGB()
        ii = SimIdeal.new(@ring,"",@pset.list);
        return ii.isGB();
    end

=begin rdoc
Compute a comprehensive Groebner base.
=end
    def CGB()
        s = @pset;
        ff = s.list;
        t = System.currentTimeMillis();
        if @gbsys == nil
            @gbsys = ComprehensiveGroebnerBaseSeq.new(@ring.ring.coFac).GBsys(ff);
        end
        gg = @gbsys.getCGB();
        t = System.currentTimeMillis() - t;
        puts "sequential comprehensive executed in #{t} ms\n"; 
        return ParamIdeal.new(@ring,"",gg,@gbsys);
    end

=begin rdoc
Compute a comprehensive Groebner system.
=end
    def CGBsystem()
        s = @pset;
        ff = s.list;
        t = System.currentTimeMillis();
        ss = ComprehensiveGroebnerBaseSeq.new(@ring.ring.coFac).GBsys(ff);
        t = System.currentTimeMillis() - t;
        puts "sequential comprehensive system executed in #{t} ms\n"; 
        return ParamIdeal.new(@ring,nil,ff,ss);
    end

=begin rdoc
Test if this is a comprehensive Groebner base.
=end
    def isCGB()
        s = @pset;
        ff = s.list;
        t = System.currentTimeMillis();
        b = ComprehensiveGroebnerBaseSeq.new(@ring.ring.coFac).isGB(ff);
        t = System.currentTimeMillis() - t;
        puts "isCGB = #{b} executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Test if this is a comprehensive Groebner system.
=end
    def isCGBsystem()
        s = @pset;
        ss = @gbsys;
        t = System.currentTimeMillis();
        b = ComprehensiveGroebnerBaseSeq.new(@ring.ring.coFac).isGBsys(ss);
        t = System.currentTimeMillis() - t;
        puts "isCGBsystem = #{b} executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Convert Groebner system to a representation with regular ring coefficents.
=end
    def regularRepresentation()
        if @gbsys == nil
            return nil;
        end
        gg = PolyUtilApp.toProductRes(@gbsys.list);
        ring = Ring.new(nil,gg[0].ring);
        return ParamIdeal.new(ring,nil,gg);
    end

=begin rdoc
Convert Groebner system to a boolean closed representation with regular ring coefficents.
=end
    def regularRepresentationBC()
        if @gbsys == nil
            return nil;
        end
        gg = PolyUtilApp.toProductRes(@gbsys.list);
        ring = Ring.new(nil,gg[0].ring);
        res = RReductionSeq.new();
        gg = res.booleanClosure(gg);
        return ParamIdeal.new(ring,nil,gg);
    end

=begin rdoc
Compute a Groebner base over a regular ring.
=end
    def regularGB()
        s = @pset;
        ff = s.list;
        t = System.currentTimeMillis();
        gg = RGroebnerBasePseudoSeq.new(@ring.ring.coFac).GB(ff);
        t = System.currentTimeMillis() - t;
        puts "sequential regular GB executed in #{t} ms\n"; 
        return ParamIdeal.new(@ring,nil,gg);
    end

=begin rdoc
Test if this is Groebner base over a regular ring.
=end
    def isRegularGB()
        s = @pset;
        ff = s.list;
        t = System.currentTimeMillis();
        b = RGroebnerBasePseudoSeq.new(@ring.ring.coFac).isGB(ff);
        t = System.currentTimeMillis() - t;
        puts "isRegularGB = #{b} executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Get each component (slice) of regular ring coefficients separate.
=end
    def stringSlice()
        s = @pset;
        b = PolyUtilApp.productToString(s);
        return b;
    end

end


=begin rdoc
Represents a JAS solvable polynomial ring: GenSolvablePolynomialRing.

Has a method to create solvable ideals.
=end
class SolvableRing < Ring

=begin rdoc
Solvable polynomial ring constructor.
=end
    def initialize(ringstr="",ring=nil)
        if ring == nil
           sr = StringReader.new( ringstr );
           tok = RingFactoryTokenizer.new(sr);
           pfac = tok.nextSolvablePolynomialRing();
           #tok = GenPolynomialTokenizer.new(sr);
           #@pset = tok.nextSolvablePolynomialSet();
           @ring = pfac;
        else
           if ring.is_a? Ring
              @ring = ring.ring
           else 
              @ring = ring;
           end
        end
        if @ring.isAssociative()
           puts "ring is associative";
        else
           puts "warning: ring is not associative";
        end
        #puts "SolvableRing to super()";
        super("",@ring) 
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @ring.toScript(); #.to_s;
    end

=begin rdoc
Create a solvable ideal.
=end
    def ideal(ringstr="",list=nil)
        return SolvIdeal.new(self,ringstr,list);
    end

=begin rdoc
Get the one of the solvable polynomial ring.
=end
    def one()
        return RingElem.new( @ring.getONE() );
    end

=begin rdoc
Get the zero of the solvable polynomial ring.
=end
    def zero()
        return RingElem.new( @ring.getZERO() );
    end

=begin rdoc
Create an element from a string or object.
=end
    def element(poly)
        if not poly.is_a? String 
           begin
              if @ring == poly.ring 
                 return RingElem.new(poly);
              end
           rescue => e
              # pass
           end
           poly = str(poly);
        end
        ii = SolvIdeal.new(self, "( " + poly + " )");
        list = ii.pset.list;
        if list.size > 0
            return RingElem.new( list[0] );
        end
    end

end


=begin rdoc
Represents a JAS solvable polynomial ring: GenSolvablePolynomialRing.

Provides more convenient constructor. 
Then returns a Ring.
=end
class SolvPolyRing < SolvableRing 

    @auto_inject = true
    @auto_lowervar = false

    class << self  # means add to class
       # inject variables into environment 
       attr_accessor :auto_inject
       # avoid capital letter variables 
       attr_accessor :auto_lowervar
    end

=begin rdoc
Ring constructor.

coeff = factory for coefficients,
vars = string with variable names,
order = term order,
rel = triple list of relations. (e,f,p,...) with e * f = p as relation.
=end
    def initialize(coeff,vars,order,rel=[])
        if coeff == nil
            raise ArgumentError, "No coefficient given."
        end
        cf = coeff;
        if coeff.is_a? RingElem
            cf = coeff.elem.factory();
        end
        if coeff.is_a? Ring
            cf = coeff.ring;
        end
        if vars == nil
            raise ArgumentError, "No variable names given."
        end
        names = vars;
        if vars.is_a? String
            names = GenPolynomialTokenizer.variableList(vars);
        end
        nv = names.size;
        #to = PolyRing.lex;
        to = PolyRing.grad;
        if order.is_a? TermOrder
            to = order;
        end
        if order.is_a? Array # ruby has no keyword params
            rel = order;
        end
        ll = [];
        for x in rel
            if x.is_a? RingElem
               x = x.elem;
            end
            ll << x;
        end
        constSolv = false;
        (0..ll.size-1).step(3) { |i|
            #puts "ll[i+1] = #{ll[i+1]}"
            if ll[i+1].isConstant()
               constSolv = true;
            end
	}
        #puts "constSolv = #{constSolv}"
        cfs = cf.toScript();
        if cfs[0] == "0"
           cfs = cf.toScriptFactory();
        end
        #puts "cf = #{cfs}"
        recSolv = cf.is_a? GenPolynomialRing
        recSolvWord = cf.is_a? GenWordPolynomialRing
        resWord = cf.is_a? WordResidueRing
        quotSolv = cf.is_a? SolvableQuotientRing
        resSolv = cf.is_a? SolvableResidueRing
        locSolv = cf.is_a? SolvableLocalRing
        locresSolv = cf.is_a? SolvableLocalResidueRing
        if recSolv and not constSolv
           recSolv = false;
        end
        #puts "cf = " + cf.getClass().to_s + ", quotSolv = " + quotSolv.to_s + ", recSolv = " + recSolv.to_s;
        if recSolv
           puts "RecSolvablePolynomialRing: " + cfs;
           ring = RecSolvablePolynomialRing.new(cf,nv,to,names);
           table = ring.table;
           coeffTable = ring.coeffTable;
        elsif recSolvWord
           puts "RecSolvableWordPolynomialRing: " + cfs;
           ring = RecSolvableWordPolynomialRing.new(cf,nv,to,names);
           table = ring.table;
           coeffTable = ring.coeffTable;
        elsif resWord
           puts "ResWordSolvablePolynomialRing: " + cfs;
           #ring = GenSolvablePolynomialRing.new(cf,nv,to,names);
           #ring = RecSolvableWordPolynomialRing.new(cf,nv,to,names);
           #ring = QLRSolvablePolynomialRing.new(cf,nv,to,names);
           ring = ResidueSolvableWordPolynomialRing.new(cf,nv,to,names);
           puts "ring = #{ring.toScript()}";
           table = ring.table;
           coeffTable = ring.polCoeff.coeffTable;
        elsif resSolv
           puts "ResidueSolvablePolynomialRing: " + cfs;
           #ring = ResidueSolvablePolynomialRing.new(cf,nv,to,names);
           ring = QLRSolvablePolynomialRing.new(cf,nv,to,names);
           table = ring.table;
           coeffTable = ring.polCoeff.coeffTable;
        elsif quotSolv
           puts "QuotSolvablePolynomialRing: " + cfs;
           #ring = QuotSolvablePolynomialRing.new(cf,nv,to,names);
           ring = QLRSolvablePolynomialRing.new(cf,nv,to,names);
           table = ring.table;
           coeffTable = ring.polCoeff.coeffTable;
        elsif locSolv
           puts "LocalSolvablePolynomialRing: " + cfs;
           #ring = LocalSolvablePolynomialRing.new(cf,nv,to,names);
           ring = QLRSolvablePolynomialRing.new(cf,nv,to,names);
           table = ring.table;
           coeffTable = ring.polCoeff.coeffTable;
        elsif locresSolv
           puts "QLRSolvablePolynomialRing: " + cfs;
           ring = QLRSolvablePolynomialRing.new(cf,nv,to,names);
           table = ring.table;
           coeffTable = ring.polCoeff.coeffTable;
        else
           puts "GenSolvablePolynomialRing: " + cfs;
           ring = GenSolvablePolynomialRing.new(cf,nv,to,names);
           table = ring.table;
           coeffTable = table;
        end
        #puts "ll = " + str(ll);
        (0..ll.size-1).step(3) { |i|
            puts "adding relation: " + str(ll[i]) + " * " + str(ll[i+1]) + " = " + str(ll[i+2]);
            if ll[i+1].isConstant() 
               if recSolv
                  #puts "r coeff type " + str(ll[i].class);
                  #coeffTable.update( ll[i], ll[i+1].leadingBaseCoefficient(), ll[i+2] );
                  coeffTable.update( ll[i], ll[i+1], ll[i+2] );
               elsif recSolvWord
                  #puts "rw coeff type " + str(ll[i].class);
                  coeffTable.update( ll[i], ll[i+1], ll[i+2] );
               elsif resWord
                  #puts "rw coeff type " + str(ll[i].class);
                  coeffTable.update( ring.toPolyCoefficients(ll[i]),
                                     ring.toPolyCoefficients(ll[i+1]), 
                                     ring.toPolyCoefficients(ll[i+2]) );
               elsif resSolv
                  #puts "ri coeff type " + str(ll[i].class);
                  coeffTable.update( ring.toPolyCoefficients(ll[i]),
                                     ring.toPolyCoefficients(ll[i+1]), 
                                     ring.toPolyCoefficients(ll[i+2]) );
                elsif quotSolv
                  #puts "q coeff type " + str(ll[i].class);
                  coeffTable.update( ring.toPolyCoefficients(ll[i]), 
                                     ring.toPolyCoefficients(ll[i+1]), 
                                     ring.toPolyCoefficients(ll[i+2]) );
                elsif locSolv
                  #puts "l coeff type " + str(ll[i].class);
                  coeffTable.update( ring.toPolyCoefficients(ll[i]),
                                     ring.toPolyCoefficients(ll[i+1]), 
                                     ring.toPolyCoefficients(ll[i+2]) );
                elsif locresSolv
                  #puts "lr coeff type " + str(ll[i].class);
                  coeffTable.update( ring.toPolyCoefficients(ll[i]),
                                     ring.toPolyCoefficients(ll[i+1]), 
                                     ring.toPolyCoefficients(ll[i+2]) );
                end
            else # no coeff relation
                #puts "ll[i], ll[i+1], ll[i+2]: " + str(ll[i]) + ", " + str(ll[i+1]) + ", " + str(ll[i+2]);
                #puts "poly type " + str(ll[i].class);
                table.update( ll[i], ll[i+1], ll[i+2] );
                if locresSolv or locSolv or quotSolv or resSolv or resWord
                   #puts "ring.polCoeff.table " + str(ring.polCoeff.table.toScript());
                   ring.polCoeff.table.update( ring.toPolyCoefficients(ll[i]),
                                               ring.toPolyCoefficients(ll[i+1]), 
                                               ring.toPolyCoefficients(ll[i+2]) );
                end
            end
	}
        #puts "ring " + ring.toScript();
        #puts "isAssoc " + str(ring.isAssociative());
        @ring = ring;
        #puts "SolvPolyRing to super()";
        super("",@ring) 
        # puts "ai = " +  self.class.auto_inject.to_s
        # done in super():
        #if self.class.auto_inject or self.class.superclass.auto_inject
        #   inject_variables();
        #end
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @ring.toScript();
    end
end


=begin rdoc
Represents a JAS solvable polynomial ideal.

Methods for left, right two-sided Groebner basees and others.
=end
class SolvIdeal
    include Comparable
    # the Java ordered polynomial list, polynomial ring, and polynomial list  
    attr_reader :pset, :ring, :list #, :ideal

=begin rdoc
Constructor for an ideal in a solvable polynomial ring.
=end
    def initialize(ring,ringstr="",list=nil)
        @ring = ring;
        if list == nil
           sr = StringReader.new( ringstr );
           tok = GenPolynomialTokenizer.new(ring.ring,sr);
           @list = tok.nextSolvablePolynomialList();
        else
           @list = rbarray2arraylist(list,rec=1);
        end
        @pset = OrderedPolynomialList.new(ring.ring,@list);
        #@ideal = SolvableIdeal.new(@pset);
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @pset.toScript();
    end

=begin rdoc
Compare two ideals.
=end
    def <=>(other)
        s = SolvableIdeal.new(@pset);
        o = SolvableIdeal.new(other.pset);
        return s.compareTo(o); 
    end

=begin rdoc
Test if two ideals are equal.
=end
    def ==(other)
        if not other.is_a? SolvIdeal
           return false;
        end
        s, o = self, other;
        return (s <=> o) == 0; 
    end

=begin rdoc
Test if ideal is one.
=end
    def isONE()
        s = SolvableIdeal.new(@pset);
        return s.isONE(); 
    end

=begin rdoc
Test if ideal is zero.
=end
    def isZERO()
        s = SolvableIdeal.new(@pset);
        return s.isZERO(); 
    end

=begin rdoc
Compute a left Groebner base.
=end
    def leftGB()
        #if ideal != nil
        #   return SolvIdeal.new(@ring,"",@ideal.leftGB());
        #end
        cofac = @ring.ring.coFac;
        ff = @pset.list;
        kind = "";
        t = System.currentTimeMillis();
        if cofac.is_a? GenPolynomialRing #and cofac.isCommutative()
           gg = SolvableGroebnerBasePseudoRecSeq.new(cofac).leftGB(ff);
           kind = "pseudoRec"
        else 
           if cofac.isField() or not cofac.isCommutative()
              gg = SolvableGroebnerBaseSeq.new().leftGB(ff);
              kind = "field|nocom"
           else
              gg = SolvableGroebnerBasePseudoSeq.new(cofac).leftGB(ff);
              kind = "pseudo"
           end
        end
        t = System.currentTimeMillis() - t;
        puts "sequential(#{kind}) leftGB executed in #{t} ms\n"; 
        return SolvIdeal.new(@ring,"",gg);
    end

=begin rdoc
Test if this is a left Groebner base.
=end
    def isLeftGB()
        cofac = @ring.ring.coFac;
        ff = @pset.list;
        kind = "";
        t = System.currentTimeMillis();
        if cofac.is_a? GenPolynomialRing #and cofac.isCommutative()
           b = SolvableGroebnerBasePseudoRecSeq.new(cofac).isLeftGB(ff);
           kind = "pseudoRec"
        else 
           if cofac.isField() or not cofac.isCommutative()
              b = SolvableGroebnerBaseSeq.new().isLeftGB(ff);
              kind = "field|nocom"
           else
              b = SolvableGroebnerBasePseudoSeq.new(cofac).isLeftGB(ff);
              kind = "pseudo"
           end
        end
        t = System.currentTimeMillis() - t;
        puts "isLeftGB(#{kind}) = #{b} executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Compute a two-sided Groebner base.
=end
    def twosidedGB()
        cofac = @ring.ring.coFac;
        ff = @pset.list;
        kind = "";
        t = System.currentTimeMillis();
        if cofac.is_a? GenPolynomialRing #and cofac.isCommutative()
           gg = SolvableGroebnerBasePseudoRecSeq.new(cofac).twosidedGB(ff);
           kind = "pseudoRec"
        else 
           #puts "two-sided: " + cofac.to_s
           if cofac.is_a? WordResidue  #Ring
              gg = SolvableGroebnerBasePseudoSeq.new(cofac).twosidedGB(ff);
              kind = "pseudo"
           else 
              if cofac.isField() or not cofac.isCommutative()
                 gg = SolvableGroebnerBaseSeq.new().twosidedGB(ff);
                 kind = "field|nocom"
              else
                 gg = SolvableGroebnerBasePseudoSeq.new(cofac).twosidedGB(ff);
                 kind = "pseudo"
              end
           end
        end
        t = System.currentTimeMillis() - t;
        puts "sequential(#{kind}) twosidedGB executed in #{t} ms\n"; 
        return SolvIdeal.new(@ring,"",gg);
    end

=begin rdoc
Test if this is a two-sided Groebner base.
=end
    def isTwosidedGB()
        cofac = @ring.ring.coFac;
        ff = @pset.list;
        kind = "";
        t = System.currentTimeMillis();
        if cofac.is_a? GenPolynomialRing #and cofac.isCommutative()
           b = SolvableGroebnerBasePseudoRecSeq.new(cofac).isTwosidedGB(ff);
           kind = "pseudoRec"
        else
           if cofac.isField() or not cofac.isCommutative()
              b = SolvableGroebnerBaseSeq.new().isTwosidedGB(ff);
              kind = "field|nocom"
           else 
              b = SolvableGroebnerBasePseudoSeq.new(cofac).isTwosidedGB(ff);
              kind = "pseudo"
           end
        end
        t = System.currentTimeMillis() - t;
        puts "isTwosidedGB(#{kind}) = #{b} executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Compute a right Groebner base.
=end
    def rightGB()
        cofac = @ring.ring.coFac;
        ff = @pset.list;
        kind = "";
        t = System.currentTimeMillis();
        if cofac.is_a? GenPolynomialRing #and cofac.isCommutative()
           gg = SolvableGroebnerBasePseudoRecSeq.new(cofac).rightGB(ff);
           kind = "pseudoRec"
        else
           if cofac.isField() or not cofac.isCommutative()
              gg = SolvableGroebnerBaseSeq.new().rightGB(ff);
              kind = "field|nocom"
           else 
              gg = SolvableGroebnerBasePseudoSeq.new(cofac).rightGB(ff);
              kind = "pseudo"
           end
        end
        t = System.currentTimeMillis() - t;
        puts "sequential(#{kind}) rightGB executed in #{t} ms\n"; 
        return SolvIdeal.new(@ring,"",gg);
    end

=begin rdoc
Test if this is a right Groebner base.
=end
    def isRightGB()
        cofac = @ring.ring.coFac;
        ff = @pset.list;
        kind = "";
        t = System.currentTimeMillis();
        if cofac.is_a? GenPolynomialRing #and cofac.isCommutative()
           b = SolvableGroebnerBasePseudoRecSeq.new(cofac).isRightGB(ff);
           kind = "pseudoRec"
        else
           if cofac.isField() or not cofac.isCommutative()
              b = SolvableGroebnerBaseSeq.new().isRightGB(ff);
              kind = "field|nocom"
           else 
              b = SolvableGroebnerBasePseudoSeq.new(cofac).isRightGB(ff);
              kind = "pseudo"
           end
        end
        t = System.currentTimeMillis() - t;
        puts "isRightGB(#{kind}) = #{b} executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Compute the intersection of this and a polynomial ring.
=end
    def intersectRing(ring)
        s = SolvableIdeal.new(@pset);
        nn = s.intersect(ring.ring);
        return SolvIdeal.new(@ring,"",nn.getList());
    end

=begin rdoc
Compute the intersection of this and the other ideal.
=end
    def intersect(other)
        s = SolvableIdeal.new(@pset);
        t = SolvableIdeal.new(other.pset);
        nn = s.intersect( t );
        return SolvIdeal.new(@ring,"",nn.getList());
    end

=begin rdoc
Compute the sum of this and the other ideal.
=end
    def sum(other)
        s = SolvableIdeal.new(@pset);
        t = SolvableIdeal.new(other.pset);
        nn = s.sum( t );
        return SolvIdeal.new(@ring,"",nn.getList());
    end

=begin rdoc
Compute the univariate polynomials in each variable of this twosided ideal.
=end
    def univariates()
        s = SolvableIdeal.new(@pset);
        ll = s.constructUnivariate();
        nn = ll.map {|e| RingElem.new(e) };
        return nn;
    end

=begin rdoc
Convert to polynomials with SolvableQuotient coefficients.
=end
    def toQuotientCoefficients()
        if @pset.ring.coFac.is_a? SolvableResidueRing
           cf = @pset.ring.coFac.ring;
        elsif @pset.ring.coFac.is_a? GenSolvablePolynomialRing
           cf = @pset.ring.coFac;
        #elsif @pset.ring.coFac.is_a? GenPolynomialRing
        #   cf = @pset.ring.coFac;
        #   puts "cf = " + cf.toScript();
        else
           return self;
        end
        rrel = @pset.ring.table.relationList() + @pset.ring.polCoeff.coeffTable.relationList();
        #puts "rrel = " + str(rrel);
        qf = SolvableQuotientRing.new(cf);
        qr = QuotSolvablePolynomialRing.new(qf,@pset.ring);
        #puts "qr = " + str(qr);
        qrel = rrel.map { |r| RingElem.new(qr.fromPolyCoefficients(r)) };
        #puts "qrel = " + str(qrel);
        qring = SolvPolyRing.new(qf,@ring.ring.getVars(),@ring.ring.tord,qrel);
        #puts "qring = " + str(qring);
        qlist = @list.map { |r| qr.fromPolyCoefficients(@ring.ring.toPolyCoefficients(r)) };
        qlist = qlist.map { |r| RingElem.new(r) };
        return SolvIdeal.new(qring,"",qlist);
    end

=begin rdoc
Compute the inverse polynomial with respect to this twosided ideal.
=end
    def inverse(p)
        if p.is_a? RingElem
            p = p.elem;
        end
        s = SolvableIdeal.new(@pset);
        i = s.inverse(p);
        return RingElem.new(i);
    end

=begin rdoc
Compute a left normal form of p with respect to this ideal.
=end
    def leftReduction(p)
        s = @pset;
        gg = s.list;
        if p.is_a? RingElem
            p = p.elem;
        end
        n = SolvableReductionSeq.new().leftNormalform(gg,p);
        return RingElem.new(n);
    end

=begin rdoc
Compute a right normal form of p with respect to this ideal.
=end
    def rightReduction(p)
        s = @pset;
        gg = s.list;
        if p.is_a? RingElem
            p = p.elem;
        end
        n = SolvableReductionSeq.new().rightNormalform(gg,p);
        return RingElem.new(n);
    end

=begin rdoc
Compute a left Groebner base in parallel.
=end
    def parLeftGB(th)
        s = @pset;
        ff = s.list;
        bbpar = SolvableGroebnerBaseParallel.new(th);
        t = System.currentTimeMillis();
        gg = bbpar.leftGB(ff);
        t = System.currentTimeMillis() - t;
        bbpar.terminate();
        puts "parallel #{th} leftGB executed in #{t} ms\n"; 
        return SolvIdeal.new(@ring,"",gg);
    end

=begin rdoc
Compute a two-sided Groebner base in parallel.
=end
    def parTwosidedGB(th)
        s = @pset;
        ff = s.list;
        bbpar = SolvableGroebnerBaseParallel.new(th);
        t = System.currentTimeMillis();
        gg = bbpar.twosidedGB(ff);
        t = System.currentTimeMillis() - t;
        bbpar.terminate();
        puts "parallel #{th} twosidedGB executed in #{t} ms\n"; 
        return SolvIdeal.new(@ring,"",gg);
    end

=begin rdoc
Left Syzygy of generating polynomials.
=end
    def leftSyzygy()
        p = @pset;
        l = p.list;
        t = System.currentTimeMillis();
        s = SolvableSyzygySeq.new(p.ring.coFac).leftZeroRelationsArbitrary( l );
        m = SolvableModule.new("",p.ring);
        t = System.currentTimeMillis() - t;
        puts "executed leftSyzygy in #{t} ms\n"; 
        return SolvableSubModule.new(m,"",s);
    end

=begin rdoc
Right Syzygy of generating polynomials.
=end
    def rightSyzygy()
        p = @pset;
        l = p.list;
        t = System.currentTimeMillis();
        s = SolvableSyzygySeq.new(p.ring.coFac).rightZeroRelationsArbitrary( l );
        m = SolvableModule.new("",p.ring);
        t = System.currentTimeMillis() - t;
        puts "executed rightSyzygy in #{t} ms\n"; 
        return SolvableSubModule.new(m,"",s);
    end

=begin rdoc
Test if this is a left syzygy of the module in m.
=end
    def isLeftSyzygy(m)
        p = @pset;
        g = p.list;
        l = m.list;
        #puts "l = #{l}"; 
        #puts "g = #{g}"; 
        t = System.currentTimeMillis();
        z = SolvableSyzygySeq.new(p.ring.coFac).isLeftZeroRelation( l, g );
        t = System.currentTimeMillis() - t;
        puts "executed isLeftSyzygy in #{t} ms\n"; 
        return z;
    end

=begin rdoc
Test if this is a right syzygy of the module in m.
=end
    def isRightSyzygy(m)
        p = @pset;
        g = p.list;
        l = m.list;
        #puts "l = #{l}"; 
        #puts "g = #{g}"; 
        t = System.currentTimeMillis();
        z = SolvableSyzygySeq.new(p.ring.coFac).isRightZeroRelation( l, g );
        t = System.currentTimeMillis() - t;
        puts "executed isRightSyzygy in #{t} ms\n"; 
        return z;
    end

end


=begin rdoc
Represents a JAS module over a polynomial ring.

Method to create sub-modules.
=end
class CommutativeModule
    # the Java polynomial ring, number of columns, module list 
    attr_reader :ring, :cols, :mset

=begin rdoc
Module constructor.
=end
    def initialize(modstr="",ring=nil,cols=0)
        if ring == nil
           sr = StringReader.new( modstr );
           tok = RingFactoryTokenizer.new(sr);
           pfac = tok.nextPolynomialRing();
           #tok = GenPolynomialTokenizer.new(sr);
           #@mset = tok.nextSubModuleSet();
           #if @mset.cols >= 0
           #    @cols = @mset.cols;
           #else
           #end
           @ring = pfac;
        else
           if ring.is_a? Ring
              @ring = ring.ring
           else 
              @ring = ring;
           end
        end
        @mset = ModuleList.new(@ring,nil);
        if cols < 0 
           cols = 0;
        end
        @cols = cols;
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @mset.toScript();
    end

=begin rdoc
Create a sub-module.
=end
    def submodul(modstr="",list=nil)
        return SubModule.new(self,modstr,list);
    end

=begin rdoc
Create an element from a string.
=end
    def element(mods)
        if not mods.is_a? String 
           begin
              if @ring == mods.ring 
                 return RingElem.new(mods);
              end
           rescue => e
              # pass
           end
           mods = str(mods);
        end
        ii = SubModule.new( "( " + mods + " )");
        list = ii.mset.list;
        if list.size > 0
            return RingElem.new( list[0] );
        end
    end

=begin rdoc
Get the generators of this module.
=end
    def gens()
        gm = GenVectorModul.new(@ring,@cols);
        ll = gm.generators();
        nn = ll.map { |e| RingElem.new(e) }; # want use val here, but can not
        return nn;
    end

end


=begin rdoc
Represents a JAS sub-module over a polynomial ring.

Methods to compute Groebner bases.
=end
class SubModule
    # the Java module, module list, polynomial list, number of columns and rows, module list 
    attr_reader :modu, :mset, :pset, :cols, :rows, :list

=begin rdoc
Constructor for a sub-module.
=end
    def initialize(modu,modstr="",list=nil)
        @modu = modu;
        if list == nil
           sr = StringReader.new( modstr );
           tok = GenPolynomialTokenizer.new(modu.ring,sr);
           @list = tok.nextSubModuleList();
        else
            if list.is_a? Array
                if list.size != 0
                    if list[0].is_a? RingElem
                        list = list.map { |re| re.elem  };
                    end
                end
                @list = rbarray2arraylist(list,@modu.ring,rec=2);
            else
                @list = list;
            end
        end
        #puts "list = ", str(list);
        #e = @list[0];
        #puts "e = ", e;
        @mset = OrderedModuleList.new(modu.ring,@list);
        @cols = @mset.cols;
        @rows = @mset.rows;
        @pset = @mset.getPolynomialList();
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @mset.toScript(); # + "\n\n" + str(@pset);
    end

=begin rdoc
Compute a Groebner base.
=end
    def GB()
        t = System.currentTimeMillis();
        #gg = ModGroebnerBaseSeq.new(@modu.ring.coFac).GB(@mset);
        gg = GroebnerBaseSeq.new().GB(@mset);
        t = System.currentTimeMillis() - t;
        puts "executed module GB in #{t} ms\n"; 
        return SubModule.new(@modu,"",gg.list);
    end

=begin rdoc
Test if this is a Groebner base.
=end
    def isGB()
        t = System.currentTimeMillis();
        #b = ModGroebnerBaseSeq.new(@modu.ring.coFac).isGB(@mset);
        b = GroebnerBaseSeq.new().isGB(@mset);
        t = System.currentTimeMillis() - t;
        puts "module isGB executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Test if this is a syzygy of the polynomials in g.
=end
    def isSyzygy(g)
        l = @list;
        if g.is_a? SimIdeal
           s = g.pset.list; # not g.list
        else 
           if g.is_a? SubModule
              s = g.mset;
              l = @mset;
           else
              raise "unknown type #{g.getClass().getName()}";
           end
        end
        #puts "l = #{l}"; 
        #puts "s = #{s}"; 
        t = System.currentTimeMillis();
        z = SyzygySeq.new(@modu.ring.coFac).isZeroRelation( l, s );
        t = System.currentTimeMillis() - t;
        puts "executed isSyzygy in #{t} ms\n"; 
        return z;
    end

=begin rdoc
Compute syzygys of this module.
=end
    def syzygy()
        l = @mset;
        t = System.currentTimeMillis();
        p = SyzygySeq.new(@modu.ring.coFac).zeroRelations( l );
        t = System.currentTimeMillis() - t;
        puts "executed module syzygy in #{t} ms\n"; 
        m = CommutativeModule.new("",p.ring,p.cols);
        return SubModule.new(m,"",p.list);
    end

end


=begin rdoc
Represents a JAS module over a solvable polynomial ring.

Method to create solvable sub-modules.
=end
class SolvableModule < CommutativeModule
    # the Java polynomial ring, number of columns, module list 
    attr_reader :ring, :cols, :mset 

=begin rdoc
Solvable module constructor.
=end
    def initialize(modstr="",ring=nil,cols=0)
        if ring == nil
           sr = StringReader.new( modstr );
           tok = RingFactoryTokenizer.new(sr);
           pfac = tok.nextSolvablePolynomialRing();
           #tok = GenPolynomialTokenizer.new(sr);
           #@mset = tok.nextSolvableSubModuleSet();
           #if @mset.cols >= 0
           #    @cols = @mset.cols;
           #end
           @ring = pfac;
        else
           if ring.is_a? Ring
              @ring = ring.ring
           else 
              @ring = ring;
           end
        end
        @mset = ModuleList.new(@ring,nil);
        if cols < 0 
           cols = 0;
        end
        @cols = cols;
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @mset.toScript();
    end

=begin rdoc
Create a solvable sub-module.
=end
    def submodul(modstr="",list=nil)
        return SolvableSubModule.new(self,modstr,list);
    end

=begin rdoc
Create an element from a string.
=end
    def element(mods)
        if not mods.is_a? String 
           begin
              if @ring == mods.ring 
                 return RingElem.new(mods);
              end
           rescue => e
              # pass
           end
           mods = str(mods);
        end
        ii = SolvableSubModule.new( "( " + mods + " )");
        list = ii.mset.list;
        if list.size > 0
            return RingElem.new( list[0] );
        end
    end

end


=begin rdoc
Represents a JAS sub-module over a solvable polynomial ring.

Methods to compute left, right and two-sided Groebner bases.
=end
class SolvableSubModule
    # the Java module, module list, number of columns and rows, module list 
    attr_reader :modu, :mset, :cols, :rows, :list

=begin rdoc
Constructor for sub-module over a solvable polynomial ring.
=end
    def initialize(modu,modstr="",list=nil)
        @modu = modu;
        if list == nil
           sr = StringReader.new( modstr );
           tok = GenPolynomialTokenizer.new(modu.ring,sr);
           @list = tok.nextSolvableSubModuleList();
        else
            if list.is_a? Array
                @list = rbarray2arraylist(list,@modu.ring,rec=2);
            else
                @list = list;
            end
        end
        @mset = OrderedModuleList.new(modu.ring,@list);
        @cols = @mset.cols;
        @rows = @mset.rows;
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @mset.toScript(); # + "\n\n" + str(@pset);
    end

=begin rdoc
Compute a left Groebner base.
=end
    def leftGB()
        t = System.currentTimeMillis();
        #gg = SolvableGroebnerBaseSeq.new(@modu.ring.coFac).leftGB(@mset);
        gg = SolvableGroebnerBaseSeq.new().leftGB(@mset);
        t = System.currentTimeMillis() - t;
        puts "executed left module GB in #{t} ms\n"; 
        return SolvableSubModule.new(@modu,"",gg.list);
    end

=begin rdoc
Test if this is a left Groebner base.
=end
    def isLeftGB()
        t = System.currentTimeMillis();
        #b = SolvableGroebnerBaseSeq.new(@modu.ring.coFac).isLeftGB(@mset);
        b = SolvableGroebnerBaseSeq.new().isLeftGB(@mset);
        t = System.currentTimeMillis() - t;
        puts "module isLeftGB executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Compute a two-sided Groebner base.
=end
    def twosidedGB()
        t = System.currentTimeMillis();
        #gg = SolvableGroebnerBaseSeq.new(@modu.ring.coFac).twosidedGB(@mset);
        gg = SolvableGroebnerBaseSeq.new().twosidedGB(@mset);
        t = System.currentTimeMillis() - t;
        puts "executed twosided module GB in #{t} ms\n"; 
        return SolvableSubModule.new(@modu,"",gg.list);
    end

=begin rdoc
Test if this is a two-sided Groebner base.
=end
    def isTwosidedGB()
        t = System.currentTimeMillis();
        #b = SolvableGroebnerBaseSeq.new(@modu.ring.coFac).isTwosidedGB(@mset);
        b = SolvableGroebnerBaseSeq.new().isTwosidedGB(@mset);
        t = System.currentTimeMillis() - t;
        puts "module isTwosidedGB executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Compute a right Groebner base.
=end
    def rightGB()
        t = System.currentTimeMillis();
        #gg = SolvableGroebnerBaseSeq.new(@modu.ring.coFac).rightGB(@mset);
        gg = SolvableGroebnerBaseSeq.new().rightGB(@mset);
        t = System.currentTimeMillis() - t;
        puts "executed right module GB in #{t} ms\n"; 
        return SolvableSubModule.new(@modu,"",gg.list);
    end

=begin rdoc
Test if this is a right Groebner base.
=end
    def isRightGB()
        t = System.currentTimeMillis();
        #b = SolvableGroebnerBaseSeq.new(@modu.ring.coFac).isRightGB(@mset);
        b = SolvableGroebnerBaseSeq.new().isRightGB(@mset);
        t = System.currentTimeMillis() - t;
        puts "module isRightGB executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Test if this is a left syzygy of the vectors in g.
=end
    def isLeftSyzygy(g)
        l = @list;
        if g.is_a? SolvIdeal
           s = g.pset.list; # not g.list
        else 
           if g.is_a? SolvableSubModule
              s = g.mset;
              l = @mset;
           else
              raise "unknown type #{g.getClass().getName()}";
           end
        end
        #puts "l = #{l}"; 
        #puts "s = #{s}"; 
        t = System.currentTimeMillis();
        z = SolvableSyzygySeq.new(@modu.ring.coFac).isLeftZeroRelation( l, s );
        t = System.currentTimeMillis() - t;
        puts "executed isLeftSyzygy in #{t} ms\n"; 
        return z;
    end

=begin rdoc
Compute left syzygys of this module.
=end
    def leftSyzygy()
        l = @mset;
        t = System.currentTimeMillis();
        p = SolvableSyzygySeq.new(@modu.ring.coFac).leftZeroRelationsArbitrary( l );
        t = System.currentTimeMillis() - t;
        puts "executed left module syzygy in #{t} ms\n"; 
        m = SolvableModule.new("",p.ring,p.cols);
        return SolvableSubModule.new(m,"",p.list);
    end

=begin rdoc
Test if this is a right syzygy of the vectors in g.
=end
    def isRightSyzygy(g)
        l = @list;
        if g.is_a? SolvIdeal
           s = g.pset.list; # not g.list
        else 
           if g.is_a? SolvableSubModule
              s = g.mset;
              l = @mset;
           else
              raise "unknown type #{g.getClass().getName()}";
           end
        end
        #puts "l = #{l}"; 
        #puts "s = #{s}"; 
        t = System.currentTimeMillis();
        z = SolvableSyzygySeq.new(@modu.ring.coFac).isRightZeroRelation( l, s );
        t = System.currentTimeMillis() - t;
        puts "executed isRightSyzygy in #{t} ms\n"; 
        return z;
    end

=begin rdoc
Compute right syzygys of this module.
=end
    def rightSyzygy()
        l = @mset;
        t = System.currentTimeMillis();
        #no: p = SolvableSyzygySeq.new(@modu.ring.coFac).rightZeroRelations( l );
        p = SolvableSyzygySeq.new(@modu.ring.coFac).rightZeroRelationsArbitrary( l );
        t = System.currentTimeMillis() - t;
        puts "executed right module syzygy in #{t} ms\n"; 
        m = SolvableModule.new("",p.ring,p.cols);
        return SolvableSubModule.new(m,"",p.list);
    end

end


java_import "edu.jas.ps.UnivPowerSeries";
java_import "edu.jas.ps.UnivPowerSeriesRing";
java_import "edu.jas.ps.UnivPowerSeriesMap";
java_import "edu.jas.ps.Coefficients";
java_import "edu.jas.ps.MultiVarPowerSeries";
java_import "edu.jas.ps.MultiVarPowerSeriesRing";
java_import "edu.jas.ps.MultiVarPowerSeriesMap";
java_import "edu.jas.ps.MultiVarCoefficients";
java_import "edu.jas.ps.StandardBaseSeq";


=begin rdoc
Represents a JAS power series ring: UnivPowerSeriesRing.

Methods for univariate power series arithmetic.
=end
class SeriesRing

    # the Java polynomial ring
    attr_reader :ring

=begin rdoc
Ring constructor.
=end
    def initialize(ringstr="",truncate=nil,ring=nil,cofac=nil,name="z")
        if ring == nil
            if ringstr.size > 0
                sr = StringReader.new( ringstr );
                tok = RingFactoryTokenizer.new(sr);
                pfac = tok.nextPolynomialRing();
                #tok = GenPolynomialTokenizer.new(sr);
                #pset = tok.nextPolynomialSet();
                ring = pfac;
                vname = ring.vars;
                name = vname[0];
                cofac = ring.coFac;
            end
            if cofac.is_a? RingElem
                cofac = cofac.elem;
            end
            if truncate == nil
                @ring = UnivPowerSeriesRing.new(cofac,name);
            else
                @ring = UnivPowerSeriesRing.new(cofac,truncate,name);
            end
        else
           @ring = ring;
        end
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @ring.toScript();
    end

=begin rdoc
Get the generators of the power series ring.
=end
    def gens()
        ll = @ring.generators();
        nn = ll.map { |e| RingElem.new(e) };
        return nn;
    end

=begin rdoc
Get the one of the power series ring.
=end
    def one()
        return RingElem.new( @ring.getONE() );
    end

=begin rdoc
Get the zero of the power series ring.
=end
    def zero()
        return RingElem.new( @ring.getZERO() );
    end

=begin rdoc
Get a random power series.
=end
    def random(n)
        return RingElem.new( @ring.random(n) );
    end

=begin rdoc
Get the exponential power series.
=end
    def exp()
        return RingElem.new( @ring.getEXP() );
    end

=begin rdoc
Get the sinus power series.
=end
    def sin()
        return RingElem.new( @ring.getSIN() );
    end

=begin rdoc
Get the cosinus power series.
=end
    def cos()
        return RingElem.new( @ring.getCOS() );
    end

=begin rdoc
Get the tangens power series.
=end
    def tan()
        return RingElem.new( @ring.getTAN() );
    end

=begin rdoc
(Inner) class which extends edu.jas.ps.Coefficients
=end
        class Ucoeff < Coefficients

=begin rdoc
Constructor.

ifunc(int i) must return a value which is used in ((RingFactory)cofac).fromInteger().
jfunc(int i) must return a value of type ring.coFac.
=end
            def initialize(ifunc,jfunc,cofac=nil)
                #puts "ifunc = " + ifunc.to_s + ",";
                #puts "jfunc = " + jfunc.to_s + ",";
                #puts "cofac = " + cofac.to_s + ",";
                super();
                if jfunc == nil && cofac == nil 
                  raise "invalid arguments"
                end
                @coFac = cofac;
                @ifunc = ifunc;
                @jfunc = jfunc;
            end

=begin rdoc
Generator for a coefficient.

long i parameter.
returns a value of type ring.coFac.
=end
            def generate(i)
                if @jfunc == nil
                    return @coFac.fromInteger( @ifunc.call(i) );
                else
                    return @jfunc.call(i);
                end
            end
        end

=begin rdoc
Create a power series with given generating function.

ifunc(int i) must return a value which is used in RingFactory.fromInteger().
jfunc(int i) must return a value of type ring.coFac.
clazz must implement the Coefficients abstract class.
=end
    def create(ifunc,jfunc=nil,clazz=nil)
        if clazz == nil
            #puts "ifunc = " + ifunc.to_s + ".";
            #puts "jfunc = " + jfunc.to_s + ".";
            #puts "clazz = " + clazz.to_s + ".";
            cf = Ucoeff.new(ifunc,jfunc,@ring.coFac);
            #puts "cf    = " + cf.to_s + ".";
            ps = UnivPowerSeries.new( @ring, cf );
        else
            ps = UnivPowerSeries.new( @ring, clazz );
        end
        return RingElem.new( ps );
    end

=begin rdoc
Create a power series as fixed point of the given mapping.

psmap must implement the UnivPowerSeriesMap interface.
=end
    def fixPoint(psmap)
        ps = @ring.fixPoint( psmap );
        return RingElem.new( ps );
    end

=begin rdoc
Compute the greatest common divisor of a and b.
=end
    def gcd(a,b)
        if a.is_a? RingElem
            a = a.elem;
        end
        if b.is_a? RingElem
            b = b.elem;
        end
        return RingElem.new( a.gcd(b) );
    end

=begin rdoc
Convert a GenPolynomial to a power series.
=end
    def fromPoly(a)
        if a.is_a? RingElem
            a = a.elem;
        end
        return RingElem.new( @ring.fromPolynomial(a) );
    end

end


=begin rdoc
Represents a JAS power series ring: MultiVarPowerSeriesRing.

Methods for multivariate power series arithmetic.
=end
class MultiSeriesRing

    # the Java polynomial ring 
    attr_reader :ring

=begin rdoc
Ring constructor.
=end
    def initialize(ringstr="",truncate=nil,ring=nil,cofac=nil,names=nil)
        if ring == nil
            if ringstr.size > 0
                sr = StringReader.new( ringstr );
                tok = RingFactoryTokenizer.new(sr);
                pfac = tok.nextPolynomialRing();
                #tok = GenPolynomialTokenizer.new(sr);
                #pset = tok.nextPolynomialSet();
                ring = pfac;
                names = ring.vars;
                cofac = ring.coFac;
            end
            if cofac.is_a? RingElem
                cofac = cofac.elem;
            end
            if names.is_a? String
               names = GenPolynomialTokenizer.variableList(names);
            end
            if truncate == nil
                @ring = MultiVarPowerSeriesRing.new(cofac,names);
            else
                nv = names.size;
                @ring = MultiVarPowerSeriesRing.new(cofac,names.size,truncate,names);
            end
        else
           @ring = ring;
        end
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @ring.toScript();
    end

=begin rdoc
Get the generators of the power series ring.
=end
    def gens()
        ll = @ring.generators();
        nn = ll.map { |e| RingElem.new(e) };
        return nn;
    end

=begin rdoc
Get the one of the power series ring.
=end
    def one()
        return RingElem.new( @ring.getONE() );
    end

=begin rdoc
Get the zero of the power series ring.
=end
    def zero()
        return RingElem.new( @ring.getZERO() );
    end

=begin rdoc
Get a random power series.
=end
    def random(n)
        return RingElem.new( @ring.random(n) );
    end

=begin rdoc
Get the exponential power series, var r.
=end
    def exp(r)
        return RingElem.new( @ring.getEXP(r) );
    end

=begin rdoc
Get the sinus power series, var r.
=end
    def sin(r)
        return RingElem.new( @ring.getSIN(r) );
    end

=begin rdoc
Get the cosinus power series, var r.
=end
    def cos(r)
        return RingElem.new( @ring.getCOS(r) );
    end

=begin rdoc
Get the tangens power series, var r.
=end
    def tan(r)
        return RingElem.new( @ring.getTAN(r) );
    end


=begin
(Inner) class which extends edu.jas.ps.MultiVarCoefficients
=end
        class Mcoeff < MultiVarCoefficients

=begin
Constructor

ring must be a polynomial or multivariate power series ring.
ifunc(ExpVector i) must return a value which is used in ((RingFactory)cofac).fromInteger().
jfunc(ExpVector i) must return a value of type ring.coFac.
=end
            def initialize(ring,ifunc=nil,jfunc=nil)
                super(ring);
                @coFac = ring.coFac;
                @ifunc = ifunc;
                @jfunc = jfunc;
            end

=begin rdoc
Generator for a coefficient.

long i parameter.
returns a value of type ring.coFac.
=end
            def generate(i)
                if @jfunc == nil
                    return @coFac.fromInteger( @ifunc.call(i) );
                else
                    return @jfunc.call(i);
                end
            end
        end

=begin rdoc
Create a power series with given generating function.

ifunc(ExpVector i) must return a value which is used in RingFactory.fromInteger().
jfunc(ExpVector i) must return a value of type ring.coFac.
clazz must implement the MultiVarCoefficients abstract class.
=end
    def create(ifunc=nil,jfunc=nil,clazz=nil)
        #puts "ifunc "
        #puts "jfunc "
        #puts "clazz " + str(clazz)
        if clazz == nil
            clazz = Mcoeff.new(@ring,ifunc,jfunc);
        end
        ps = MultiVarPowerSeries.new( @ring, clazz );
        #puts "ps ", ps.toScript();
        return RingElem.new( ps );
    end

=begin rdoc
Create a power series as fixed point of the given mapping.

psmap must implement the MultiVarPowerSeriesMap interface.
=end
    def fixPoint(psmap)
        ps = @ring.fixPoint( psmap );
        return RingElem.new( ps );
    end

=begin rdoc
Compute the greatest common divisor of a and b.
=end
    def gcd(a,b)
        if a.is_a? RingElem
            a = a.elem;
        end
        if b.is_a? RingElem
            b = b.elem;
        end
        return RingElem.new( a.gcd(b) );
    end

=begin rdoc
Convert a GenPolynomial to a power series.
=end
    def fromPoly(a)
        if a.is_a? RingElem
            a = a.elem;
        end
        return RingElem.new( @ring.fromPolynomial(a) );
    end

end


=begin rdoc
Represents a JAS power series ideal.

Method for Standard bases.
=end
class PSIdeal

    # the Java powerseries ring, powerseries list 
    attr_reader :ring, :list

=begin rdoc
PSIdeal constructor.
=end
    def initialize(ring,polylist,ideal=nil,list=nil)
        if ring.is_a? Ring or ring.is_a? PolyRing
            ring = MultiVarPowerSeriesRing.new(ring.ring);
        elsif ring.is_a? MultiSeriesRing
            ring = ring.ring;
        end
        @ring = ring;
        #puts "ring = ", ring.toScript();
        if ideal != nil
           polylist = ideal.pset.list;
        end
        if list == nil
            @polylist = rbarray2arraylist( polylist.map { |a| a.elem } );
            #puts "polylist = ", @polylist;
            @list = @ring.fromPolynomial(@polylist);
        else
            @polylist = nil;
            @list = rbarray2arraylist( list.map { |a| a.elem } );
        end
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return "( " + @list.map { |a| a.toScript() }.join(", ") + " )";
    end

=begin rdoc
Compute a standard base.
=end
    def STD(trunc=nil)
        pr = @ring;
        if trunc != nil
            pr.setTruncate(trunc);
        end
        #puts "pr = ", pr.toScript();
        ff = @list;
        #puts "ff = ", ff;
        tm = StandardBaseSeq.new();
        t = System.currentTimeMillis();
        ss = tm.STD(ff);
        t = System.currentTimeMillis() - t;
        puts "sequential standard base executed in #{t} ms\n";
        #Sp = [ RingElem.new(a.asPolynomial()) for a in S ];
        sp = ss.map { |a| RingElem.new(a) };
        #return sp;
        return PSIdeal.new(@ring,nil,nil,sp);
    end

end


=begin rdoc
(Was inner) class which extends edu.jas.ps.Coefficients
=end
class Coeff < Coefficients

=begin rdoc
Constructor.

cof RingFactory for coefficients.
f(int i) must return a value of type cof.
=end
  def initialize(cof,&f)
      super() # this is important in jruby 1.5.6!
      #puts "cof type(#{cof}) = #{cof.class}\n";
      @coFac = cof;
      #puts "f type(#{f}) = #{f.class}\n";
      @func = f
  end

=begin rdoc
Generator for a coefficient.

long i parameter.
returns a value of type cof.
=end
  def generate(i)
      #puts "f_3  type(#{@func}) = #{@func.class}\n";
      #puts "f_3  type(#{i}) = #{i.class}\n";
      #return @coFac.getZERO()
      c = @func.call(i)
      #puts "f_3  type(#{c}) = #{c.class}\n";
      if c.is_a? RingElem
          c = c.elem
      end
      return c
  end
end


=begin rdoc
Create JAS UnivPowerSeries as ring element.
=end
def PS(cofac,name,truncate=nil,&f) #=nil,truncate=nil)
    cf = cofac;
    if cofac.is_a? RingElem
        cf = cofac.elem.factory();
    end
    if cofac.is_a? Ring
        cf = cofac.ring;
    end
    if truncate.is_a? RingElem
        truncate = truncate.elem;
    end
    if truncate == nil
        ps = UnivPowerSeriesRing.new(cf,name);
    else
        ps = UnivPowerSeriesRing.new(cf,truncate,name);
    end
    #puts "ps type(#{ps}) = #{ps.class}\n";
    #puts "f  type(#{f}) = #{f.class}\n";
    if f == nil
        r = ps.getZERO();
    else
        #Bug in JRuby 1.5.6? move outside method
        r = UnivPowerSeries.new(ps,Coeff.new(cf,&f));
    end
    return RingElem.new(r);

end


=begin rdoc
(Was inner) class which extends edu.jas.ps.MultiVarCoefficients
=end
class MCoeff < MultiVarCoefficients

=begin rdoc
Constructor.

r polynomial RingFactory.
f(ExpVector e) must return a value of type r.coFac.
=end
  def initialize(r,&f)
      super(r) # this is important in jruby 1.5.6!
      @coFac = r.coFac;
      @func = f
  end

=begin rdoc
Generator for a coefficient.

ExpVector e parameter.
returns a value of type r.coFac
=end
  def generate(i)
      a = @func.call(i);
      if a.is_a? RingElem
         a = a.elem;
      end
      #puts "f_5  type(#{a}) = #{a.class}\n";
      return a;
  end
end


=begin rdoc
Create JAS MultiVarPowerSeries as ring element.
=end
def MPS(cofac,names,truncate=nil,&f)
    cf = cofac;
    if cofac.is_a? RingElem
        cf = cofac.elem.factory();
    elsif cofac.is_a? Ring
        cf = cofac.ring;
    end
    vars = names;
    if vars.is_a? String
       vars = GenPolynomialTokenizer.variableList(vars);
    end
    nv = vars.size;
    if truncate.is_a? RingElem
        truncate = truncate.elem;
    end
    if truncate == nil
        ps = MultiVarPowerSeriesRing.new(cf,nv,vars);
    else
        ps = MultiVarPowerSeriesRing.new(cf,nv,vars,truncate);
    end
    if f == nil
        r = ps.getZERO();
    else
        r = MultiVarPowerSeries.new(ps,MCoeff.new(ps,&f));
        #puts "r = " + str(r);
    end
    return RingElem.new(r);

end

java_import "edu.jas.vector.GenVector";
java_import "edu.jas.vector.GenVectorModul";
java_import "edu.jas.vector.GenMatrix";
java_import "edu.jas.vector.GenMatrixRing";


=begin rdoc
Create JAS GenVector ring element.
=end
def Vec(cofac,n,v=nil)
    cf = cofac;
    if cofac.is_a? RingElem
        cf = cofac.elem.factory();
    elsif cofac.is_a? Ring
        cf = cofac.ring;
    end
    if n.is_a? RingElem
        n = n.elem;
    end
    if v.is_a? RingElem
        v = v.elem;
    end
    vr = GenVectorModul.new(cf,n);
    if v == nil
        r = GenVector.new(vr);
    else
        r = GenVector.new(vr,v);
    end
    return RingElem.new(r);
end

=begin rdoc
Create JAS GenMatrix ring element.
=end
def Mat(cofac,n,m,v=nil)
    cf = cofac;
    if cofac.is_a? RingElem
        cf = cofac.elem.factory();
    elsif cofac.is_a? Ring
        cf = cofac.ring;
    end
    if n.is_a? RingElem
        n = n.elem;
    end
    if m.is_a? RingElem
        m = m.elem;
    end
    if v.is_a? RingElem
        v = v.elem;
    end
    #puts "cf type(#{cf}) = #{cf.class}";
    if v.is_a? Array
        v = rbarray2arraylist(v,cf,rec=2);
    end
    mr = GenMatrixRing.new(cf,n,m);
    if v == nil
        r = GenMatrix.new(mr);
    else
        r = GenMatrix.new(mr,v);
    end
    return RingElem.new(r);
end


java_import "edu.jas.application.ExtensionFieldBuilder";

=begin rdoc
Extension field builder.
Construction of extension field towers according to then builder pattern.
=end
class EF

    # the Java extension field builder 
    attr_reader :builder

=begin rdoc
Constructor to set base field.
=end
    def initialize(base)
        if base.is_a? RingElem
            #factory = base.elem;
            factory = base.ring;
        else
            factory = base;
        end
        begin
            factory = factory.factory();
        rescue
            #pass
        end
        puts "extension field factory: " + factory.toScript(); # + " :: " + factory.toString();
        if factory.is_a? ExtensionFieldBuilder
            @builder = factory;
        else
            @builder = ExtensionFieldBuilder.new(factory);
        end
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @builder.toScript(); 
        #return @builder.toString(); 
    end

=begin rdoc 
Create an extension field.  If algebraic is given as
string expression, then an algebraic extension field is constructed,
else a transcendental extension field is constructed.  
=end 
    def extend(vars,algebraic=nil) 
        if algebraic == nil
            ef = @builder.transcendentExtension(vars);
        else
            ef = @builder.algebraicExtension(vars,algebraic);
        end
        return EF.new(ef.build());
    end

=begin rdoc
Create a real extension field.
Construct a real algebraic extension field with an isolating interval for a real root.
=end
    def realExtend(vars,algebraic,interval)
        ef = @builder.realAlgebraicExtension(vars,algebraic,interval);
        return EF.new(ef.build());
    end

=begin rdoc
Create a complex extension field.
Construct a complex algebraic extension field with an isolating rectangle for a complex root.
=end
    def complexExtend(vars,algebraic,rectangle)
        ef = @builder.complexAlgebraicExtension(vars,algebraic,rectangle);
        return EF.new(ef.build());
    end

=begin rdoc
Create an polynomial ring extension.
=end
    def polynomial(vars)
        ef = @builder.polynomialExtension(vars);
        return EF.new(ef.build());
    end

=begin rdoc
Get extension field tower.
=end
    def build()
        rf = @builder.build();
        if rf.is_a? GenPolynomialRing
            return PolyRing.new(rf.coFac,rf.getVars(),rf.tord);
        else
            return RingElem.new(rf.getZERO());
        end
    end

end


=begin rdoc
Represents a JAS non-commutative polynomial ring: GenWordPolynomialRing.

Has a method to create non-commutative ideals.
<b>Note:</b> watch your step: check that jruby does not reorder multiplication.
=end
class WordRing < Ring

=begin rdoc
Word polynomial ring constructor.
=end
    def initialize(ringstr="",ring=nil)
        if ring == nil
           #raise "parse of word polynomial rings not implemented"
           sr = StringReader.new( ringstr );
           tok = RingFactoryTokenizer.new(sr);
           pfac = tok.nextPolynomialRing();
           wfac = GenWordPolynomialRing.new(pfac);
           #@list = tok.nextWordPolynomialList(wfac);
           @ring = wfac;
        else
           if ring.is_a? Ring
              @ring = ring.ring
           else 
              @ring = ring;
           end
        end
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @ring.toScript(); #.to_s;
    end

=begin rdoc
Create a word ideal.
=end
    def ideal(ringstr="",list=nil)
        return WordPolyIdeal.new(self, ringstr, list);
    end

=begin rdoc
Get the one of the word polynomial ring.
=end
    def one()
        return RingElem.new( @ring.getONE() );
    end

=begin rdoc
Get the zero of the word polynomial ring.
=end
    def zero()
        return RingElem.new( @ring.getZERO() );
    end

=begin rdoc
Get a random word polynomial.
=end
    def random(n=5)
        r = @ring.random(n);
        if @ring.coFac.isField()
            r = r.monic();
        end
        return RingElem.new( r );
    end

=begin rdoc
Get a random word polynomial.
=end
    def random(k=5,l=7,d=3)
        r = @ring.random(k,l,d);
        if @ring.coFac.isField()
            r = r.monic();
        end
        return RingElem.new( r );
    end

=begin rdoc
Create an element from a string or object.
=end
    def element(poly)
        if not poly.is_a? String 
           begin
              if @ring == poly.ring 
                 return RingElem.new(poly);
              end
           rescue => e
              # pass
           end
           poly = str(poly);
        end
        ii = WordPolyIdeal.new(self, "( " + poly + " )"); # should work
        list = ii.list;
        if list.size > 0
            return RingElem.new( list[0] );
        end
    end

end


=begin rdoc
Represents a JAS non-commutative polynomial ring: GenWordPolynomialRing.

Provides more convenient constructor. 
Then returns a Ring.
<b>Note:</b> watch your step: check that jruby does not reorder multiplication.
=end
class WordPolyRing < WordRing

=begin rdoc
Ring constructor.

coeff = factory for coefficients,
vars = string with variable names.
=end
    def initialize(coeff,vars)
        if coeff == nil
            raise ArgumentError, "No coefficient given."
        end
        cf = coeff;
        if coeff.is_a? RingElem
            cf = coeff.elem.factory();
        end
        if coeff.is_a? Ring
            cf = coeff.ring;
        end
        if vars == nil
            raise ArgumentError, "No variable names given."
        end
        names = vars;
        if vars.is_a? String
            names = GenPolynomialTokenizer.variableList(vars);
        end
        wf = WordFactory.new(names);
        @ring = GenWordPolynomialRing.new(cf, wf);
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        return @ring.toScript();
    end
end


=begin rdoc
Represents a JAS non-commutative polynomial ideal.

Methods for two-sided Groebner bases and others.
<b>Note:</b> watch your step: check that jruby does not reorder multiplication.
=end
class WordPolyIdeal

    # the Java word polynomial ring, word polynomial list, word ideal
    attr_reader :ring, :list, :ideal

=begin rdoc
Constructor for an ideal in a non-commutative polynomial ring.
=end
    def initialize(ring,ringstr="",list=nil)
        @ring = ring;
        if list == nil
           #raise "parse of non-commutative polynomials not implemented"
           sr = StringReader.new( ringstr );
           tok = GenPolynomialTokenizer.new(sr);
           @list = tok.nextWordPolynomialList(ring.ring);
           @ideal = WordIdeal.new(ring.ring, @list);
        else
           if list.is_a? WordIdeal
              @list = list.list;
              @ideal = list;
           else 
              @list = rbarray2arraylist(list, rec=1);
              @ideal = WordIdeal.new(ring.ring, @list);
           end
        end
    end

=begin rdoc
Create a string representation.
=end
    def to_s()
        # return "( " + @list.map{ |e| e.toScript() }.join(", ") + " )";
        #return "( " + @list.map{ |e| e.toScript() }.join(",\n") + " )";
        return @ideal.toScript();
    end

=begin rdoc
Compute a two-sided Groebner base.
=end
    def GB()
        return twosidedGB();
    end

=begin rdoc
Compute a two-sided Groebner base.
=end
    def twosidedGB()
        cofac = @ring.ring.coFac;
        kind = "";
        t = System.currentTimeMillis();
        if cofac.isField() or not cofac.isCommutative()
           gg = @ideal.GB();
           kind = "field|nocom"
        else 
            #puts "is ring: " + str(cofac.is_a? GenPolynomialRing)
            if cofac.is_a? GenPolynomialRing #and cofac.isCommutative()
               ff = @ideal.list;
               fg = WordGroebnerBasePseudoRecSeq.new(cofac).GB(ff);
               @ideal = WordIdeal.new(ring.ring, fg);
               kind = "pseudoRec"
            else
               ff = @ideal.list;
               fg = WordGroebnerBasePseudoSeq.new(cofac).GB(ff);
               @ideal = WordIdeal.new(ring.ring, fg);
               kind = "pseudo"
            end
        end
        t = System.currentTimeMillis() - t;
        puts "executed(#{kind}) twosidedGB in #{t} ms\n"; 
        return self;
    end

=begin rdoc
Test if this is a two-sided Groebner base.
=end
    def isGB()
        return isTwosidedGB();
    end

=begin rdoc
Test if this is a two-sided Groebner base.
=end
    def isTwosidedGB()
        cofac = @ring.ring.coFac;
        kind = "";
        t = System.currentTimeMillis();
        if cofac.isField() or not cofac.isCommutative()
           b = @ideal.isGB();
           kind = "field|nocom"
        else 
            if cofac.is_a? GenPolynomialRing
               ff = @ideal.list;
               b = WordGroebnerBasePseudoRecSeq.new(cofac).isGB(ff);
               kind = "pseudoRec"
            else
               ff = @ideal.list;
               b = WordGroebnerBasePseudoSeq.new(cofac).isGB(ff);
               kind = "pseudo"
            end
        end
        t = System.currentTimeMillis() - t;
        puts "isTwosidedGB(#{kind}) = #{b} executed in #{t} ms\n"; 
        return b;
    end

=begin rdoc
Compare two ideals.
=end
    def <=>(other)
        s = @ideal; 
        o = other.ideal; 
        return s.compareTo(o); 
    end

=begin rdoc
Test if two ideals are equal.
=end
    def ==(other)
        if not other.is_a? WordPolyIdeal
           return false;
        end
        s = @ideal; 
        t = other.ideal; 
        return s.equals(t); 
    end

=begin rdoc
Compute the sum of this and the ideal.
=end
    def sum(other)
        s = @ideal; 
        t = other.ideal; 
        nn = s.sum( t );
        return WordPolyIdeal.new(@ring,"",nn);
    end

end


=begin rdoc
Create JAS polynomial WordResidue as ring element.
=end
def WRC(ideal,r=0)
    if ideal == nil
        raise ArgumentError, "No ideal given."
    end
    if ideal.is_a? WordPolyIdeal
        #puts "ideal = " + str(ideal) + "\n";
        #ideal = Java::EduJasApplication::WordIdeal.new(ideal.ring,ideal.list);
        ideal = ideal.ideal;
        #ideal.doGB();
    end
    if not ideal.is_a? WordIdeal
        raise ArgumentError, "No word ideal given."
    end
    #puts "ideal.getList().get(0).ring.ideal = #{ideal.getList().get(0).ring.ideal}\n";
    if ideal.getList().get(0).ring.is_a? WordResidueRing
        rc = WordResidueRing.new( ideal.getList().get(0).ring.ideal );
    else
        rc = WordResidueRing.new(ideal);
    end
    if r.is_a? RingElem
        r = r.elem;
    end
    if r == 0
        r = WordResidue.new(rc);
    else
        r = WordResidue.new(rc,r);
    end
    return RingElem.new(r);
end


# define some shortcuts
# big integers
ZZ = ZZ();
# big rational numbers
QQ = QQ();
# complex big rational numbers
CC = CC();
#generic complex numbers
CR = CR();
#big decimal numbers
DD = DD();
#no GF = GF();

end

include JAS
