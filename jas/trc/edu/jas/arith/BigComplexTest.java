/*
 * $Id$
 */

package edu.jas.arith;


import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;


/**
 * BigComplex tests with JUnit.
 * @author Heinz Kredel
 */

public class BigComplexTest extends TestCase {


    /**
     * main
     */
    public static void main(String[] args) {
        junit.textui.TestRunner.run(suite());
    }


    /**
     * Constructs a <CODE>BigComplexTest</CODE> object.
     * @param name String.
     */
    public BigComplexTest(String name) {
        super(name);
    }


    /**
     * suite.
     */
    public static Test suite() {
        TestSuite suite = new TestSuite(BigComplexTest.class);
        return suite;
    }


    BigComplex a, b, c, d, e;


    BigComplex fac;


    @Override
    protected void setUp() {
        a = b = c = d = e = null;
        fac = new BigComplex();
    }


    @Override
    protected void tearDown() {
        a = b = c = d = e = null;
        fac = null;
    }


    /**
     * Test static initialization and constants.
     */
    public void testConstants() {
        a = BigComplex.ZERO;
        b = BigComplex.ONE;
        c = BigComplex.CDIF(b, b);
        d = BigComplex.I;
        e = BigComplex.CDIF(d, d);

        assertEquals("1-1 = 0", c, a);
        assertTrue("1-1 = 0", c.isZERO());
        assertTrue("1 = 1", b.isONE());
        assertEquals("1-1 = 0", c, a);
        assertTrue("i = i", d.isIMAG());
        assertTrue("i-i = 0", e.isZERO());
    }


    /**
     * Test bitLength.
     */
    public void testBitLength() {
        a = BigComplex.ZERO;
        b = BigComplex.ONE;
        c = BigComplex.CDIF(b, b);
        d = BigComplex.I;
        e = BigComplex.CDIF(d, d);

        assertEquals("len(0) = 6", 6, a.bitLength());
        assertEquals("len(1) = 7", 7, b.bitLength());
        assertEquals("len(-1) = 7", 7, b.negate().bitLength());
        assertEquals("len(i) = 7", 7, d.bitLength());
        assertEquals("len(-i) = 7", 7, d.negate().bitLength());

        e = BigComplex.CDIF(b, d);
        assertEquals("len(1-i) = 8", 8, e.bitLength());
    }


    /**
     * Test constructor and toString.
     */
    public void testConstructor() {
        a = new BigComplex("6/8");
        b = new BigComplex("3/4");

        assertEquals("6/8 = 3/4", a, b);

        a = new BigComplex("3/4 i 4/5");
        b = new BigComplex("-3/4 i -4/5");

        assertEquals("3/4 + i 4/5 ", a, b.negate());

        String s = "6/1111111111111111111111111111111111111111111";
        a = new BigComplex(s);
        String t = a.toString();

        assertEquals("stringConstr = toString", s, t);

        a = new BigComplex(1);
        b = new BigComplex(-1);
        c = BigComplex.CSUM(b, a);

        assertTrue("1 = 1", a.isONE());
        assertEquals("1+(-1) = 0", c, BigComplex.ZERO);
    }


    /**
     * Test random rationals.
     */
    public void testRandom() {
        a = BigComplex.CRAND(500);
        b = new BigComplex(a.getRe(), a.getIm());
        c = BigComplex.CDIF(b, a);

        assertEquals("a-b = 0", c, BigComplex.ZERO);

        d = new BigComplex(b.getRe(), b.getIm());
        assertEquals("sign(a-a) = 0", 0, b.compareTo(d));
    }


    /**
     * Test addition.
     */
    public void testAddition() {
        a = BigComplex.CRAND(100);
        b = BigComplex.CSUM(a, a);
        c = BigComplex.CDIF(b, a);

        assertEquals("a+a-a = a", c, a);
        assertEquals("a+a-a = a", 0, c.compareTo(a));

        b = fac.random(5);
        c = a.sum(b);
        d = b.sum(a);
        assertEquals("a+b == b+a: " + c.subtract(d), c, d);

        d = BigComplex.CSUM(a, BigComplex.ZERO);
        assertEquals("a+0 = a", d, a);
        d = BigComplex.CDIF(a, BigComplex.ZERO);
        assertEquals("a-0 = a", d, a);
        d = BigComplex.CDIF(a, a);
        assertEquals("a-a = 0", d, BigComplex.ZERO);
    }


    /**
     * Test multiplication.
     */
    public void testMultiplication() {
        a = BigComplex.CRAND(100);
        b = BigComplex.CPROD(a, a);
        c = BigComplex.CQ(b, a);

        assertEquals("a*a/a = a", c, a);
        assertEquals("a*a/a = a", 0, c.compareTo(a));

        d = BigComplex.CPROD(a, BigComplex.ONE);
        assertEquals("a*1 = a", d, a);
        d = BigComplex.CQ(a, BigComplex.ONE);
        assertEquals("a/1 = a", d, a);

        b = fac.random(5);
        c = a.multiply(b);
        d = b.multiply(a);
        assertEquals("a*b == b*a: " + c.subtract(d), c, d);

        a = BigComplex.CRAND(100);
        b = BigComplex.CINV(a);
        c = BigComplex.CPROD(a, b);

        assertTrue("a*1/a = 1", c.isONE());
    }


    /**
     * Test distributive law.
     */
    public void testDistributive() {
        BigComplex fac = new BigComplex();
        a = fac.random(500);
        b = fac.random(500);
        c = fac.random(500);

        d = a.multiply(b.sum(c));
        e = a.multiply(b).sum(a.multiply(c));

        assertEquals("a(b+c) = ab+ac", d, e);
    }


    /**
     * Test power and abs.
     */
    public void testOther() {
        BigComplex fac = new BigComplex();
        a = fac.random(100);
        b = a.multiply(a);
        c = a.power(2);

        assertEquals("a*a == a**2", b, c);

        d = b.abs();
        c = b.norm();
        //System.out.println("a = " + a);
        //System.out.println("b = " + b);
        //System.out.println("c = " + c);
        //System.out.println("d = " + d);
        BigDecimal dd = new BigDecimal(d.re);
        BigDecimal cd = new BigDecimal(c.re);
        int t = dd.power(2).compareToRelative(cd);
        assertTrue("abs(a)**2 ~= norm(a): ", t == 0);
    }

}
