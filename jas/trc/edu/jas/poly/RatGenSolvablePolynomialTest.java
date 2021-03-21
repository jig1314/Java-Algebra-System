/*
 * $Id$
 */

package edu.jas.poly;


import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;


import edu.jas.arith.BigRational;


/**
 * BigRational coefficients GenSolvablePolynomial tests with JUnit.
 * @author Heinz Kredel
 */

public class RatGenSolvablePolynomialTest extends TestCase {


    /**
     * main.
     */
    public static void main(String[] args) {
        junit.textui.TestRunner.run(suite());
    }


    /**
     * Constructs a <CODE>RatGenSolvablePolynomialTest</CODE> object.
     * @param name String.
     */
    public RatGenSolvablePolynomialTest(String name) {
        super(name);
    }


    /**
     */
    public static Test suite() {
        TestSuite suite = new TestSuite(RatGenSolvablePolynomialTest.class);
        return suite;
    }


    GenSolvablePolynomial<BigRational> a, b, c, d, e, f, x1, x2;


    int rl = 5;


    int kl = 10;


    int ll = 5;


    int el = 3;


    float q = 0.5f;


    RelationTable<BigRational> table;


    GenSolvablePolynomialRing<BigRational> ring;


    BigRational cfac;


    @Override
    protected void setUp() {
        cfac = new BigRational(1);
        ring = new GenSolvablePolynomialRing<BigRational>(cfac, rl);
        table = ring.table;
        a = b = c = d = e = null;
    }


    @Override
    protected void tearDown() {
        table = null;
        ring = null;
        a = b = c = d = e = null;
    }


    /**
     * Test constructor and toString.
     */
    public void testConstructor() {
        a = new GenSolvablePolynomial<BigRational>(ring);
        assertTrue("length( a ) = 0", a.length() == 0);
        assertTrue("isZERO( a )", a.isZERO());
        assertTrue("isONE( a )", !a.isONE());

        c = ring.getONE();
        assertTrue("length( c ) = 1", c.length() == 1);
        assertTrue("isZERO( c )", !c.isZERO());
        assertTrue("isONE( c )", c.isONE());

        d = ring.getZERO();
        assertTrue("length( d ) = 0", d.length() == 0);
        assertTrue("isZERO( d )", d.isZERO());
        assertTrue("isONE( d )", !d.isONE());
    }


    /**
     * Test random polynomial.
     */
    public void testRandom() {
        assertTrue("isCommutative()", ring.isCommutative());

        for (int i = 0; i < 2; i++) {
            // a = ring.random(ll+2*i);
            a = ring.random(kl * (i + 1), ll + 2 * i, el + i, q);
            assertTrue("length( a" + i + " ) <> 0", a.length() >= 0);
            assertTrue(" not isZERO( a" + i + " )", !a.isZERO());
            assertTrue(" not isONE( a" + i + " )", !a.isONE());
        }
    }


    /**
     * Test addition.
     */
    public void testAddition() {
        a = ring.random(kl, ll, el, q);

        c = (GenSolvablePolynomial<BigRational>) a.subtract(a);
        assertTrue("a-a = 0", c.isZERO());

        b = (GenSolvablePolynomial<BigRational>) a.sum(a);
        c = (GenSolvablePolynomial<BigRational>) b.subtract(a);

        assertEquals("a+a-a = a", c, a);
        assertTrue("a+a-a = a", c.equals(a));

        b = ring.random(kl, ll, el, q);
        c = (GenSolvablePolynomial<BigRational>) b.sum(a);
        d = (GenSolvablePolynomial<BigRational>) a.sum(b);

        assertEquals("a+b = b+a", c, d);
        assertTrue("a+b = b+a", c.equals(d));

        c = ring.random(kl, ll, el, q);
        d = (GenSolvablePolynomial<BigRational>) a.sum(b.sum(c));
        e = (GenSolvablePolynomial<BigRational>) a.sum(b).sum(c);

        assertEquals("a+(b+c) = (a+b)+c", d, e);
        assertTrue("a+(b+c) = (a+b)+c", d.equals(e));

        ExpVector u = ExpVector.random(rl, el, q);
        BigRational x = cfac.random(kl);

        b = ring.getONE().multiply(x, u);
        c = (GenSolvablePolynomial<BigRational>) a.sum(b);
        d = (GenSolvablePolynomial<BigRational>) a.sum(x, u);
        assertEquals("a+p(x,u) = a+(x,u)", c, d);

        c = (GenSolvablePolynomial<BigRational>) a.subtract(b);
        d = (GenSolvablePolynomial<BigRational>) a.subtract(x, u);
        assertEquals("a-p(x,u) = a-(x,u)", c, d);

        a = ring.getZERO();
        b = ring.getONE().multiply(x, u);
        c = (GenSolvablePolynomial<BigRational>) b.sum(a);
        d = (GenSolvablePolynomial<BigRational>) a.sum(x, u);
        assertEquals("a+p(x,u) = a+(x,u)", c, d);

        c = (GenSolvablePolynomial<BigRational>) a.subtract(b);
        d = (GenSolvablePolynomial<BigRational>) a.subtract(x, u);
        assertEquals("a-p(x,u) = a-(x,u)", c, d);
    }


    /**
     * Test object multiplication.
     */
    @SuppressWarnings("cast")
    public void testMultiplication() {
        a = ring.random(kl, ll, el, q);
        assertTrue("not isZERO( a )", !a.isZERO());
        //a = RatGenSolvablePolynomial.DIRRAS(1, kl, 4, el, q );

        b = ring.random(kl, ll, el, q);
        assertTrue("not isZERO( b )", !b.isZERO());

        c = b.multiply(a);
        d = a.multiply(b);
        assertTrue("not isZERO( c )", !c.isZERO());
        assertTrue("not isZERO( d )", !d.isZERO());

        e = (GenSolvablePolynomial<BigRational>) d.subtract(c);
        assertTrue("isZERO( a*b-b*a ) " + e, e.isZERO());

        assertEquals("a*b = b*a", c, d);
        assertTrue("a*b = b*a", c.equals(d));

        c = ring.random(kl, ll, el, q);
        d = a.multiply(b.multiply(c));
        e = (a.multiply(b)).multiply(c);

        assertEquals("a(bc) = (ab)c", d, e);
        assertTrue("a(bc) = (ab)c", d.equals(e));

        BigRational x = a.leadingBaseCoefficient().inverse();
        c = (GenSolvablePolynomial<BigRational>) a.monic();
        d = a.multiply(x);
        assertEquals("a.monic() = a(1/ldcf(a))", c, d);

        ExpVector u = ring.evzero;
        BigRational y = b.leadingBaseCoefficient().inverse();
        c = (GenSolvablePolynomial<BigRational>) b.monic();
        d = b.multiply(y, u);
        assertEquals("b.monic() = b(1/ldcf(b))", c, d);

        e = ring.getONE().multiply(y, u);
        d = b.multiply(e);
        assertEquals("b.monic() = b(1/ldcf(b))", c, d);

        d = e.multiply(b);
        assertEquals("b.monic() = (1/ldcf(b) (0))*b", c, d);

        d = a.monic();
        assertTrue("a.monic(): ", d.leadingBaseCoefficient().isONE());
    }


    /**
     * Test Weyl polynomials.
     */
    public void testWeyl() {
        int rloc = 4;
        ring = new GenSolvablePolynomialRing<BigRational>(cfac, rloc);

        RelationGenerator<BigRational> wl = new WeylRelations<BigRational>();
        wl.generate(ring);
        table = ring.table;
        //System.out.println("table = " + table);
        //System.out.println("ring = " + ring);

        assertFalse("isCommutative()", ring.isCommutative());
        assertTrue("isAssociative()", ring.isAssociative());

        a = ring.random(kl, ll, el, q);
        assertTrue("not isZERO( a )", !a.isZERO());
        //System.out.println("a = " + a);

        b = ring.random(kl, ll, el, q);
        assertTrue("not isZERO( b )", !b.isZERO());
        //System.out.println("b = " + b);


        // non commutative
        c = b.multiply(a);
        d = a.multiply(b);
        //System.out.println("c = " + c);
        //System.out.println("d = " + d);
        assertTrue("not isZERO( c )", !c.isZERO());
        assertTrue("not isZERO( d )", !d.isZERO());

        e = (GenSolvablePolynomial<BigRational>) d.subtract(c);
        assertTrue("!isZERO( a*b-b*a ) " + e, !e.isZERO());
        assertTrue("a*b != b*a", c.equals(d) || c.leadingExpVector().equals(d.leadingExpVector()));

        c = ring.random(kl, ll, el, q);
        //System.out.println("\na = " + a);
        //System.out.println("\nb = " + b);
        //System.out.println("\nc = " + c);

        // associative
        //x1 = b.multiply(c);
        //System.out.println("\nx1 = " + x1);
        d = a.multiply(b.multiply(c));

        //x2 = a.multiply(b);
        //System.out.println("\nx2 = " + x2);
        e = a.multiply(b).multiply(c);

        //System.out.println("\nd = " + d);
        //System.out.println("\ne = " + e);

        //f = (GenSolvablePolynomial<BigRational>)d.subtract(e);
        //System.out.println("\nf = " + f);

        assertEquals("a(bc) = (ab)c", d, e);
        assertTrue("a(bc) = (ab)c", d.equals(e));
    }


    /**
     * Test division of polynomials.
     */
    public void testDivide() {
        int rloc = 4;
        ring = new GenSolvablePolynomialRing<BigRational>(cfac, rloc);

        RelationGenerator<BigRational> wl = new WeylRelations<BigRational>();
        wl.generate(ring);
        //System.out.println("ring = " + ring.toScript());

        assertFalse("isCommutative()", ring.isCommutative());
        assertTrue("isAssociative()", ring.isAssociative());

        do {
            a = ring.random(kl, ll, el, q);
        } while(a.isZERO());
        //System.out.println("a = " + a);

        do {
            b = ring.random(kl, ll, el, q);
        } while(b.isZERO());
        //System.out.println("b = " + b);

        // non commutative
        c = b.multiply(a);
        d = a.multiply(b);
        //System.out.println("c = " + c);
        //System.out.println("d = " + d);
        assertTrue("not isZERO( c )", !c.isZERO());
        assertTrue("not isZERO( d )", !d.isZERO());

        e = (GenSolvablePolynomial<BigRational>) d.subtract(c);
        assertTrue("a*b != b*a", !c.equals(d) || c.leadingExpVector().equals(d.leadingExpVector()));

        // divide 
        e = c.divide(a);
        //System.out.println("e = " + e);
        f = c.rightDivide(b);
        //System.out.println("f = " + f);
        assertEquals("b == b*a/a: " + e, e, b);
        assertEquals("a == b*a/b: " + e, f, a);

        e = d.rightDivide(a);
        //System.out.println("e = " + e);
        f = d.divide(b);
        //System.out.println("f = " + f);
        assertEquals("b == a*b/a: " + e, e, b);
        assertEquals("a == a*b/b: " + e, f, a);
    }


    /**
     * Test distributive law.
     */
    public void testDistributive() {
        int rloc = 4;
        ring = new GenSolvablePolynomialRing<BigRational>(cfac, rloc);

        RelationGenerator<BigRational> wl = new WeylRelations<BigRational>();
        wl.generate(ring);
        //table = ring.table;
        //System.out.println("table = " + table);
        //System.out.println("ring = " + ring);

        a = ring.random(kl, ll, el, q);
        b = ring.random(kl, ll, el, q);
        c = ring.random(kl, ll, el, q);

        d = a.multiply((GenSolvablePolynomial<BigRational>) b.sum(c));
        e = (GenSolvablePolynomial<BigRational>) a.multiply(b).sum(a.multiply(c));

        assertEquals("a(b+c) = ab+ac", d, e);
    }
}
