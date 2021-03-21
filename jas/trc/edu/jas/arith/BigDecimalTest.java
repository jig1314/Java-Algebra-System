/*
 * $Id$
 */

package edu.jas.arith;


import java.math.MathContext;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;


/**
 * BigDecimal tests with JUnit.
 * @author Heinz Kredel
 */

public class BigDecimalTest extends TestCase {


    /**
     * main.
     */
    public static void main(String[] args) {
        junit.textui.TestRunner.run(suite());
    }


    /**
     * Constructs a <CODE>BigDecimalTest</CODE> object.
     * @param name String.
     */
    public BigDecimalTest(String name) {
        super(name);
    }


    /**
     */
    public static Test suite() {
        TestSuite suite = new TestSuite(BigDecimalTest.class);
        return suite;
    }


    BigDecimal a, b, c, d, e, eps;


    BigDecimal fac;


    int precision = BigDecimal.DEFAULT_PRECISION; // 100; // must match default


    MathContext mc = BigDecimal.DEFAULT_CONTEXT; // new MathContext( precision );


    int kl = precision / 2;


    @Override
    protected void setUp() {
        a = b = c = d = e = null;
        fac = new BigDecimal(0L, mc);
        eps = new BigDecimal(new BigRational(1,10));
        eps = eps.power(precision);
    }


    @Override
    protected void tearDown() {
        a = b = c = d = e = null;
        fac = null;
        eps = null;
    }


    /**
     * Test static initialization and constants.
     */
    public void testConstants() {
        a = BigDecimal.ZERO;
        b = BigDecimal.ONE;
        c = b.subtract(b);

        assertTrue("1-1 = 0", c.compareTo(a) == 0);
        assertTrue("1-1 = 0", c.isZERO());
        assertTrue("1 = 1", b.isONE());

        a = BigDecimal.ZERO;
        b = BigDecimal.ONE;
        c = a.subtract(a);

        assertTrue("1-1 = 0", c.compareTo(a) == 0);
    }


    /**
     * Test bitLength.
     */
    public void testBitLength() {
        a = BigDecimal.ZERO;
        b = BigDecimal.ONE;
        c = b.random(300, 100);
        //System.out.println("c = " + c);
        //System.out.println("unscale(c) = " + c.val.unscaledValue());
        //System.out.println("scale(c) = " + c.val.scale());
        //System.out.println("len(c) = " + c.bitLength());

        assertEquals("len(0) = 1", 2, a.bitLength());
        assertEquals("len(1) = 3", 3, b.bitLength());
        assertEquals("len(-1) = 3", 3, b.negate().bitLength());
        assertTrue("len(random) >= 2", 2 <= c.bitLength());
    }


    /**
     * Test constructor and toString.
     */
    public void testConstructor() {
        a = new BigDecimal("6.8");
        b = new BigDecimal("3.4");
        b = b.sum(b);

        assertEquals("6.8 = 3.4", 0, a.compareTo(b));

        String s = "6.1111111111111111111111111111111111111111111";
        a = new BigDecimal(s);
        String t = a.toString();

        assertEquals("stringConstr = toString", s, t);

        a = new BigDecimal(1);
        b = new BigDecimal(-1);
        c = b.sum(a);

        assertTrue("1 = 1", a.isONE());
        assertTrue("1+(-1) = 0", c.compareTo(BigDecimal.ZERO) == 0);
        assertTrue("1+(-1) = 0", c.isZERO());
    }


    /**
     * Test random rationals.
     */
    public void testRandom() {
        a = fac.random(5 * kl);
        //System.out.println("a = " + a);
        b = new BigDecimal("" + a);
        c = a.subtract(a);

        //System.out.println("c = " + c);
        //assertTrue("a-b = 0", c.compareTo(BigDecimal.ZERO)==0 );
        assertTrue("a-b = 0", c.isZERO());

        d = new BigDecimal("" + b);
        //System.out.println("b = " + b);
        //System.out.println("d = " + d);
        assertTrue("sign(a-a) = 0", b.compareTo(d) == 0);
    }


    /**
     * Test addition.
     */
    public void testAddition() {
        a = fac.random(kl);
        b = a.sum(a);
        c = b.subtract(a);
        //System.out.println("a = " + a);
        //System.out.println("b = " + b);
        //System.out.println("c = " + c);

        //assertEquals("a+a-a = a", c, a);
        assertEquals("a+a-a = a", 0, c.compareTo(a));

        d = a.sum(BigDecimal.ZERO);
        assertEquals("a+0 = a", 0, d.compareTo(a));
        d = a.subtract(BigDecimal.ZERO);
        assertEquals("a-0 = a", 0, d.compareTo(a));
        d = a.subtract(a);
        assertTrue("a-a = 0", d.compareTo(BigDecimal.ZERO) == 0);

        b = fac.random(kl);
        c = a.sum(b);
        d = b.sum(a);
        assertTrue("a+b = b+a", d.compareTo(c) == 0);

        // addition is not associative
    }


    /**
     * Test multiplication. Is not associative.
     */
    public void testMultiplication() {
        a = fac.random(kl);
        b = a.multiply(a);
        c = b.divide(a);
        //System.out.println("a = " + a);
        //System.out.println("b = " + b);
        //System.out.println("c = " + c);

        //assertEquals("a*a/a = a",c,a);
        assertTrue("a*a/a = a", c.compareTo(a) == 0);

        d = a.multiply(BigDecimal.ONE);
        assertEquals("a*1 = a", d, a);
        d = a.divide(BigDecimal.ONE);
        assertEquals("a/1 = a", 0, d.compareTo(a));

        a = fac.random(kl);
        b = a.inverse();
        c = a.multiply(b);
        //System.out.println("c = " + c);
        d = c.subtract(fac.getONE()).abs();
        assertTrue("a*1/a = 1: " + c, d.compareTo(eps) <= 0);

        b = fac.random(kl);
        c = a.multiply(b);
        d = b.multiply(a);
        //System.out.println("c = " + c);
        //System.out.println("d = " + d);
        assertTrue("ab = ba", d.compareTo(c) == 0);

        c = fac.random(kl);
        d = a.multiply(b.multiply(c));
        e = a.multiply(b).multiply(c);
        //System.out.println("d = " + d);
        //System.out.println("e = " + e);
        if (d.compareTo(e) == 0) {
            assertTrue("a(bc) = (ab)c", d.compareTo(e) == 0);
        }
    }


    /**
     * Test distributive law. Does not hold.
     */
    public void testDistributive() {
        a = fac.random(kl);
        b = fac.random(kl);
        c = fac.random(kl);

        d = a.multiply(b.sum(c));
        e = a.multiply(b).sum(a.multiply(c));
        if (d.compareTo(e) == 0) {
            assertTrue("a(b+c) = ab+ac", d.compareTo(e) == 0);
        }
    }

}
