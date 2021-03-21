/*
 * $Id$
 */

package edu.jas.arith;


import java.util.List;

import edu.jas.structure.Power;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;


/**
 * Basic arithmetic tests with JUnit.
 * @author Heinz Kredel
 */

public class ArithTest extends TestCase {


    /**
     * main.
     */
    public static void main(String[] args) {
        junit.textui.TestRunner.run(suite());
    }


    /**
     * Constructs a <CODE>ArithTest</CODE> object.
     * @param name String.
     */
    public ArithTest(String name) {
        super(name);
    }


    /**
     * suite.
     */
    public static Test suite() {
        TestSuite suite = new TestSuite(ArithTest.class);
        return suite;
    }


    @Override
    protected void setUp() {
        //a = b = c = d = e = null;
    }


    @Override
    protected void tearDown() {
        //a = b = c = d = e = null;
    }


    /**
     * Test static initialization and constants for BigInteger.
     */
    public void testIntegerConstants() {
        BigInteger a, b, c, d;
        a = BigInteger.ZERO;
        b = BigInteger.ONE;
        c = b.subtract(b);

        assertTrue("0.isZERO()", a.isZERO());
        assertTrue("1.isONE", b.isONE());

        assertEquals("1-1 = 0", c, a);
        assertTrue("(1-1).isZERO()", c.isZERO());

        d = b.multiply(b);
        assertTrue("1*1 = 1", d.isONE());

        d = b.multiply(a);
        assertTrue("1*0 = 0", d.isZERO());
    }


    //--------------------------------------------------------


    /**
     * Test string constructor and toString for BigInteger.
     */
    public void testIntegerConstructor() {
        BigInteger a, b, c, d;
        a = new BigInteger(1);
        b = new BigInteger(-1);
        c = new BigInteger(0);

        d = a.sum(b);
        assertTrue("'1'.isONE()", a.isONE());
        assertTrue("1+(-1) = 0", d.isZERO());
        d = a.negate();
        assertEquals("-1 = -(1)", d, b);

        d = a.multiply(c);
        assertTrue("'0'.isZERO()", d.isZERO());
        d = b.multiply(b);
        assertTrue("(-1)*(-1) = 1", d.isONE());

        a = new BigInteger(3);
        b = new BigInteger("3");
        assertEquals("3 = '3'", a, b);

        a = new BigInteger(-5);
        b = new BigInteger("-5");
        assertEquals("-5 = '-5'", a, b);

        //          0         1         2         3         4 
        //          0123456789012345678901234567890123456789012345
        String s = "1111111111111111111111111111111111111111111111";
        a = new BigInteger(s);
        String t = a.toString();
        assertEquals("stringConstr = toString", s, t);
    }


    //--------------------------------------------------------

    /**
     * Test random and compares Integer.
     */
    public void testIntegerRandom() {
        BigInteger a, b, c;
        a = BigInteger.ZERO.random(500);
        b = new BigInteger("" + a);
        c = b.subtract(a);

        assertTrue("a-'a' = 0", c.isZERO());
        assertEquals("compareTo('a',a) = 0", 0, b.compareTo(a));
        assertEquals("signum('a'-a) = 0", 0, c.signum());
    }


    //--------------------------------------------------------


    /**
     * Test addition for Integer.
     */
    public void testIntegerAddition() {
        BigInteger a, b, c, d, e;
        // neutral element
        a = BigInteger.ZERO.random(500);
        d = a.sum(BigInteger.ZERO);
        assertEquals("a+0 = a", d, a);
        d = a.subtract(BigInteger.ZERO);
        assertEquals("a-0 = a", d, a);

        // inverse operations
        b = a.sum(a);
        c = b.subtract(a);
        assertEquals("(a+a)-a = a", c, a);
        b = a.subtract(a);
        c = b.sum(a);
        assertEquals("(a-a)+a = a", c, a);

        // comutativity
        b = BigInteger.ZERO.random(500);
        c = a.sum(b);
        d = b.sum(a);
        assertEquals("a+b = b+a", c, d);

        // negation
        c = a.subtract(b);
        d = a.sum(b.negate());
        assertEquals("a-b = a+(-b)", c, d);

        // associativity
        c = BigInteger.ZERO.random(500);
        d = a.sum(b.sum(c));
        e = a.sum(b).sum(c);
        assertEquals("a+(b+c) = (a+b)+c", d, e);
    }


    //--------------------------------------------------------


    /**
     * Test multiplication for Integer.
     */
    public void testIntegerMultiplication() {
        BigInteger a, b, c, d, e;
        // neutral element
        a = BigInteger.ZERO.random(500);
        d = a.multiply(BigInteger.ONE);
        assertEquals("a*1 = a", d, a);
        d = a.divide(BigInteger.ONE);
        assertEquals("a/1 = a", d, a);

        // inverse operations
        b = a.multiply(a);
        c = b.divide(a);
        assertEquals("(a*a)/a = a", c, a);
        b = a.divide(a);
        c = b.multiply(a);
        assertEquals("(a/a)*a = a", c, a);

        // comutativity
        b = BigInteger.ZERO.random(500);
        c = a.multiply(b);
        d = b.multiply(a);
        assertEquals("a*b = b*a", c, d);

        // inverse
        d = c.divide(b);
        // e = c.multiply( b.inverse() );
        e = a;
        assertEquals("a/b = a*(1/b)", d, e);

        // associativity
        c = BigInteger.ZERO.random(500);
        d = a.multiply(b.multiply(c));
        e = a.multiply(b).multiply(c);
        assertEquals("a*(b*c) = (a*b)*c", d, e);
    }


    /**
     * Test static initialization and constants for BigRational.
     */
    public void testRationalConstants() {
        BigRational a, b, c, d;
        a = BigRational.ZERO;
        b = BigRational.ONE;
        //System.out.println("a = " + a);
        //System.out.println("b = " + b);
        c = b.subtract(b);

        assertTrue("0.isZERO()", a.isZERO());
        assertTrue("1.isONE", b.isONE());

        assertEquals("1-1 = 0", c, a);
        assertTrue("(1-1).isZERO()", c.isZERO());

        d = b.multiply(b);
        assertTrue("1*1 = 1", d.isONE());

        d = b.multiply(a);
        assertTrue("1*0 = 0", d.isZERO());
    }


    /**
     * Test static initialization and constants for BigComplex.
     */
    public void testComplexConstants() {
        BigComplex a, b, c, d;
        a = BigComplex.ZERO;
        b = BigComplex.ONE;
        c = b.subtract(b);

        assertTrue("0.isZERO()", a.isZERO());
        assertTrue("1.isONE", b.isONE());

        assertEquals("1-1 = 0", c, a);
        assertTrue("(1-1).isZERO()", c.isZERO());

        d = b.multiply(b);
        assertTrue("1*1 = 1", d.isONE());

        d = b.multiply(a);
        assertTrue("1*0 = 0", d.isZERO());
    }


    /**
     * Test static initialization and constants for BigQuaternion.
     */
    public void testQuaternionConstants() {
        BigQuaternionRing fac = new BigQuaternionRing();
        BigQuaternion a, b, c, d;
        a = fac.ZERO;
        b = fac.ONE;
        c = b.subtract(b);

        assertTrue("0.isZERO()", a.isZERO());
        assertTrue("1.isONE", b.isONE());

        assertEquals("1-1 = 0", c, a);
        assertTrue("(1-1).isZERO()", c.isZERO());

        d = b.multiply(b);
        assertTrue("1*1 = 1", d.isONE());

        d = b.multiply(a);
        assertTrue("1*0 = 0", d.isZERO());
    }


    //--------------------------------------------------------


    /**
     * Test string constructor and toString for BigRational.
     */
    public void testRationalConstructor() {
        BigRational a, b, c, d;
        a = new BigRational(1);
        b = new BigRational(-1);
        c = new BigRational(0);

        d = a.sum(b);
        assertTrue("'1'.isONE()", a.isONE());
        assertTrue("1+(-1) = 0", d.isZERO());
        d = a.negate();
        assertEquals("-1 = -(1)", d, b);

        d = a.multiply(c);
        assertTrue("'0'.isZERO()", d.isZERO());
        d = b.multiply(b);
        assertTrue("(-1)*(-1) = 1", d.isONE());

        a = new BigRational(3);
        b = new BigRational("3");
        assertEquals("3 = '3'", a, b);

        a = new BigRational(-5);
        b = new BigRational("-5");
        assertEquals("-5 = '-5'", a, b);

        //          0         1         2         3         4 
        //          0123456789012345678901234567890123456789012345
        String s = "1111111111111111111111111111111111111111111111";
        a = new BigRational(s);
        String t = a.toString();
        assertEquals("stringConstr = toString", s, t);

        s = "2/4";
        a = new BigRational(s);
        t = a.toString(5);
        //System.out.println("a = " + a);
        //System.out.println("t = " + t);
        String r = "0.5";
        assertEquals("stringConstr = toString", r, t);
    }


    /**
     * Test string constructor and toString for BigComplex.
     */
    public void testComplexConstructor() {
        BigComplex a, b, c, d;
        a = new BigComplex(1);
        b = new BigComplex(-1);
        c = new BigComplex(0);

        d = a.sum(b);
        assertTrue("'1'.isONE()", a.isONE());
        assertTrue("1+(-1) = 0", d.isZERO());
        d = a.negate();
        assertEquals("-1 = -(1)", d, b);

        d = a.multiply(c);
        assertTrue("'0'.isZERO()", d.isZERO());
        d = b.multiply(b);
        assertTrue("(-1)*(-1) = 1", d.isONE());

        a = new BigComplex(3);
        b = new BigComplex("3");
        assertEquals("3 = '3'", a, b);

        a = new BigComplex(-5);
        b = new BigComplex("-5");
        assertEquals("-5 = '-5'", a, b);

        //          0         1         2         3         4 
        //          0123456789012345678901234567890123456789012345
        String s = "1111111111111111111111111111111111111111111111";
        a = new BigComplex(s);
        String t = a.toString();
        assertEquals("stringConstr = toString", s, t);
    }


    /**
     * Test string constructor and toString for BigQuaternion.
     */
    public void testQuaternionConstructor() {
        BigQuaternionRing fac = new BigQuaternionRing();
        BigQuaternion a, b, c, d;
        a = new BigQuaternion(fac, 1);
        b = new BigQuaternion(fac, -1);
        c = new BigQuaternion(fac, 0);

        d = a.sum(b);
        assertTrue("'1'.isONE()", a.isONE());
        assertTrue("1+(-1) = 0", d.isZERO());
        d = a.negate();
        assertEquals("-1 = -(1)", d, b);

        d = a.multiply(c);
        assertTrue("'0'.isZERO()", d.isZERO());
        d = b.multiply(b);
        assertTrue("(-1)*(-1) = 1", d.isONE());

        a = new BigQuaternion(fac, 3);
        b = new BigQuaternion(fac, "3");
        assertEquals("3 = '3'", a, b);

        a = new BigQuaternion(fac, -5);
        b = new BigQuaternion(fac, "-5");
        assertEquals("-5 = '-5'", a, b);

        //          0         1         2         3         4 
        //          0123456789012345678901234567890123456789012345
        String s = "1111111111111111111111111111111111111111111111";
        a = new BigQuaternion(fac, s);
        String t = a.toString();
        assertEquals("stringConstr = toString", s, t);
    }


    //--------------------------------------------------------


    /**
     * Test random and compares Rational.
     */
    public void testRationalRandom() {
        BigRational a, b, c;
        a = BigRational.ZERO.random(500);
        b = new BigRational("" + a);
        c = b.subtract(a);

        assertTrue("a-'a' = 0", c.isZERO());
        assertEquals("compareTo('a',a) = 0", 0, b.compareTo(a));
        assertEquals("signum('a'-a) = 0", 0, c.signum());
    }


    /**
     * Test random and compares Complex.
     */
    public void testComplexRandom() {
        BigComplex a, b, c;
        a = BigComplex.ZERO.random(500);
        b = new BigComplex("" + a);
        c = b.subtract(a);

        assertTrue("a-'a' = 0", c.isZERO());
        assertEquals("compareTo('a',a) = 0", 0, b.compareTo(a));
        assertEquals("signum('a'-a) = 0", 0, c.signum());
    }


    /**
     * Test random and compares Quaternion.
     */
    public void testQuaternionRandom() {
        BigQuaternionRing fac = new BigQuaternionRing();
        BigQuaternion a, b, c;
        a = fac.random(500);
        b = new BigQuaternion(fac, a.toString());
        c = b.subtract(a);

        assertTrue("a-'a' = 0", c.isZERO());
        assertEquals("signum('a'-a) = 0", 0, c.signum());
        assertEquals("compareTo('a',a) = 0", 0, b.compareTo(a));
    }


    //--------------------------------------------------------


    /**
     * Test addition for Rational.
     */
    public void testRationalAddition() {
        BigRational a, b, c, d, e;
        // neutral element
        a = BigRational.ZERO.random(500);
        d = a.sum(BigRational.ZERO);
        assertEquals("a+0 = a", d, a);
        d = a.subtract(BigRational.ZERO);
        assertEquals("a-0 = a", d, a);

        // inverse operations
        b = a.sum(a);
        c = b.subtract(a);
        assertEquals("(a+a)-a = a", c, a);
        b = a.subtract(a);
        c = b.sum(a);
        assertEquals("(a-a)+a = a", c, a);

        // comutativity
        b = BigRational.ZERO.random(500);
        c = a.sum(b);
        d = b.sum(a);
        assertEquals("a+b = b+a", c, d);

        // negation
        c = a.subtract(b);
        d = a.sum(b.negate());
        assertEquals("a-b = a+(-b)", c, d);

        // associativity
        c = BigRational.ZERO.random(500);
        d = a.sum(b.sum(c));
        e = a.sum(b).sum(c);
        assertEquals("a+(b+c) = (a+b)+c", d, e);
    }


    /**
     * Test addition for Complex.
     */
    public void testComplexAddition() {
        BigComplex a, b, c, d, e;
        // neutral element
        a = BigComplex.ZERO.random(500);
        d = a.sum(BigComplex.ZERO);
        assertEquals("a+0 = a", d, a);
        d = a.subtract(BigComplex.ZERO);
        assertEquals("a-0 = a", d, a);

        // inverse operations
        b = a.sum(a);
        c = b.subtract(a);
        assertEquals("(a+a)-a = a", c, a);
        b = a.subtract(a);
        c = b.sum(a);
        assertEquals("(a-a)+a = a", c, a);

        // comutativity
        b = BigComplex.ZERO.random(500);
        c = a.sum(b);
        d = b.sum(a);
        assertEquals("a+b = b+a", c, d);

        // negation
        c = a.subtract(b);
        d = a.sum(b.negate());
        assertEquals("a-b = a+(-b)", c, d);

        // associativity
        c = BigComplex.ZERO.random(500);
        d = a.sum(b.sum(c));
        e = a.sum(b).sum(c);
        assertEquals("a+(b+c) = (a+b)+c", d, e);
    }


    /**
     * Test addition for Quaternion.
     */
    public void testQuaternionAddition() {
        BigQuaternionRing fac = new BigQuaternionRing();
        BigQuaternion a, b, c, d, e;
        // neutral element
        a = fac.random(500);
        d = a.sum(fac.ZERO);
        assertEquals("a+0 = a", d, a);
        d = a.subtract(fac.ZERO);
        assertEquals("a-0 = a", d, a);

        // inverse operations
        b = a.sum(a);
        c = b.subtract(a);
        assertEquals("(a+a)-a = a", c, a);
        b = a.subtract(a);
        c = b.sum(a);
        assertEquals("(a-a)+a = a", c, a);

        // comutativity
        b = fac.random(500);
        c = a.sum(b);
        d = b.sum(a);
        assertEquals("a+b = b+a", c, d);

        // negation
        c = a.subtract(b);
        d = a.sum(b.negate());
        assertEquals("a-b = a+(-b)", c, d);

        // associativity
        c = fac.random(500);
        d = a.sum(b.sum(c));
        e = a.sum(b).sum(c);
        assertEquals("a+(b+c) = (a+b)+c", d, e);
    }


    //--------------------------------------------------------


    /**
     * Test multiplication for Rational.
     */
    public void testRationalMultiplication() {
        BigRational a, b, c, d, e;
        // neutral element
        a = BigRational.ZERO.random(500);
        d = a.multiply(BigRational.ONE);
        assertEquals("a*1 = a", d, a);
        d = a.divide(BigRational.ONE);
        assertEquals("a/1 = a", d, a);

        // inverse operations
        b = a.multiply(a);
        c = b.divide(a);
        assertEquals("(a*a)/a = a", c, a);
        b = a.divide(a);
        c = b.multiply(a);
        assertEquals("(a/a)*a = a", c, a);

        // comutativity
        b = BigRational.ZERO.random(500);
        c = a.multiply(b);
        d = b.multiply(a);
        assertEquals("a*b = b*a", c, d);

        // inverse
        d = c.divide(b);
        e = c.multiply(b.inverse());
        //e = a;
        assertEquals("a/b = a*(1/b)", d, e);

        // associativity
        c = BigRational.ZERO.random(500);
        d = a.multiply(b.multiply(c));
        e = a.multiply(b).multiply(c);
        assertEquals("a*(b*c) = (a*b)*c", d, e);
    }


    /**
     * Test multiplication for Complex.
     */
    public void testComplexMultiplication() {
        BigComplex a, b, c, d, e;
        // neutral element
        a = BigComplex.ZERO.random(500);
        d = a.multiply(BigComplex.ONE);
        assertEquals("a*1 = a", d, a);
        d = a.divide(BigComplex.ONE);
        assertEquals("a/1 = a", d, a);

        // inverse operations
        b = a.multiply(a);
        c = b.divide(a);
        assertEquals("(a*a)/a = a", c, a);
        b = a.divide(a);
        c = b.multiply(a);
        assertEquals("(a/a)*a = a", c, a);

        // comutativity
        b = BigComplex.ZERO.random(500);
        c = a.multiply(b);
        d = b.multiply(a);
        assertEquals("a*b = b*a", c, d);

        // inverse
        d = c.divide(b);
        e = c.multiply(b.inverse());
        //e = a;
        assertEquals("a/b = a*(1/b)", d, e);

        // associativity
        c = BigComplex.ZERO.random(500);
        d = a.multiply(b.multiply(c));
        e = a.multiply(b).multiply(c);
        assertEquals("a*(b*c) = (a*b)*c", d, e);
    }


    /**
     * Test multiplication for Quaternion.
     */
    public void testQuaternionMultiplication() {
        BigQuaternionRing fac = new BigQuaternionRing();
        BigQuaternion a, b, c, d, e;
        // neutral element
        a = fac.random(500);
        d = a.multiply(fac.ONE);
        assertEquals("a*1 = a", d, a);
        d = a.divide(fac.ONE);
        assertEquals("a/1 = a", d, a);

        // inverse operations
        b = a.multiply(a);
        c = b.divide(a);
        assertEquals("(a*a)/a = a", c, a);
        b = a.divide(a);
        c = b.multiply(a);
        assertEquals("(a/a)*a = a", c, a);

        // inverse
        b = fac.random(500);
        c = b.multiply(a);
        d = c.divide(b);
        e = c.multiply(b.inverse());
        //e = a;
        assertEquals("a/b = a*(1/b)", d, e);

        // associativity
        c = fac.random(500);
        d = a.multiply(b.multiply(c));
        e = a.multiply(b).multiply(c);
        assertEquals("a*(b*c) = (a*b)*c", d, e);

        // non comutativity
        a = fac.I;
        b = fac.J;
        c = a.multiply(b);
        d = b.multiply(a);
        assertEquals("I*J = -J*I", c, d.negate());
        a = fac.I;
        b = fac.K;
        c = a.multiply(b);
        d = b.multiply(a);
        assertEquals("I*K = -K*I", c, d.negate());
        a = fac.J;
        b = fac.K;
        c = a.multiply(b);
        d = b.multiply(a);
        assertEquals("J*K = -K*J", c, d.negate());
    }


    /**
     * Test power for Rational.
     */
    public void testRationalPower() {
        BigRational a, b, c, d;
        a = BigRational.ZERO.random(100);

        // power operations
        b = Power.<BigRational> positivePower(a, 1);
        assertEquals("a^1 = a", b, a);

        Power<BigRational> pow = new Power<BigRational>(BigRational.ONE);
        b = pow.power(a, 1);
        assertEquals("a^1 = a", b, a);

        b = pow.power(a, 2);
        c = a.multiply(a);
        assertEquals("a^2 = a*a", b, c);

        d = pow.power(a, -2);
        c = b.multiply(d);
        assertTrue("a^2 * a^-2 = 1", c.isONE());

        b = pow.power(a, 3);
        c = a.multiply(a).multiply(a);
        assertEquals("a^3 = a*a*a", b, c);

        d = pow.power(a, -3);
        c = b.multiply(d);
        assertTrue("a^3 * a^-3 = 1", c.isONE());

        //Java 8:
        d = a.power(-3);
        c = b.multiply(d);
        assertTrue("a^3 * a^-3 = 1", c.isONE());
    }


    /**
     * Test power for Integer.
     */
    public void testIntegerPower() {
        BigInteger a, b, c, d, e;
        a = BigInteger.ZERO.random(500);

        // power operations
        b = Power.<BigInteger> positivePower(a, 1);
        assertEquals("a^1 = a", b, a);

        Power<BigInteger> pow = new Power<BigInteger>(BigInteger.ONE);
        b = pow.power(a, 1);
        assertEquals("a^1 = a", b, a);

        b = pow.power(a, 2);
        c = a.multiply(a);
        assertEquals("a^2 = a*a", b, c);

        b = pow.power(a, 3);
        c = a.multiply(a).multiply(a);
        assertEquals("a^3 = a*a*a", b, c);

        // mod power operations
        a = new BigInteger(3);
        b = Power.<BigInteger> positivePower(a, 1);
        assertEquals("a^1 = a", b, a);

        a = new BigInteger(11);
        e = new BigInteger(2);
        c = Power.<BigInteger> modPositivePower(a, 10, e);
        assertTrue("3^n mod 2 = 1", c.isONE());

        // little fermat
        a = BigInteger.ZERO.random(500);
        b = new BigInteger(11);
        c = Power.<BigInteger> modPositivePower(a, 11, b);
        d = a.remainder(b);
        assertEquals("a^p = a mod p", c, d);

        c = pow.modPower(a, 11, b);
        assertEquals("a^p = a mod p", c, d);

        //Java 8:
        a = BigInteger.ZERO.random(100);
        d = a.power(1);
        c = a;
        assertEquals("a^1 == a", c, d);

        d = a.power(0);
        c = BigInteger.ONE;
        assertEquals("a^0 == 1", c, d);

        d = a.power(3);
        c = a.multiply(a).multiply(a);
        assertEquals("a^3 == a*a*a", c, d);
    }


    /**
     * Test Combinatoric.
     */
    public void testCombinatoric() {
        BigInteger a, b, c;

        a = Combinatoric.binCoeff(5, 0);
        assertTrue("(5 0) == 1 ", a.isONE());

        a = Combinatoric.binCoeff(5, 7);
        //System.out.println(5 + " over " + 7 + " = " + a);
        assertTrue("(5 7) == 1 ", a.isONE());

        int n = 7;
        for (int k = 0; k <= n; k++) {
            a = Combinatoric.binCoeff(n, k);
            b = Combinatoric.binCoeff(n, n - k);
            assertEquals("(5 k) == (5 5-k) ", b, a);
            //System.out.println(n + " over " + k + " = " + a);
        }
        assertTrue("(5 5) == 1 ", a.isONE());

        b = Combinatoric.binCoeffSum(n, n);
        //System.out.println("sum( " + n + " over " + n + " ) = " + b);
        c = Power.positivePower(new BigInteger(2), n);
        assertEquals("sum(5 5) == 1 ", b, c);

        b = Combinatoric.factorial(3);
        assertEquals("3! == 6 ", b, new BigInteger(6));
        b = Combinatoric.factorial(0);
        assertEquals("0! == 1 ", b, new BigInteger(1));
    }


    /**
     * Test square root.
     */
    public void testSquareRoot() {
        BigInteger a, b, c, d, e, f;
        a = BigInteger.ONE;

        b = a.random(47).abs();
        //b = c.multiply(c);
        d = Roots.sqrtInt(b);
        //System.out.println("b          = " + b);
        //System.out.println("root       = " + d);
        e = d.multiply(d);
        //System.out.println("root^2     = " + e);
        assertTrue("root^2 <= a ", e.compareTo(b) <= 0);
        d = d.sum(BigInteger.ONE);
        f = d.multiply(d);
        //System.out.println("(root+1)^2 = " + f);
        assertTrue("(root+1)^2 >= a ", f.compareTo(b) >= 0);

        c = Roots.sqrt(b);
        //System.out.println("b          = " + b);
        //System.out.println("root       = " + c);
        e = c.multiply(c);
        //System.out.println("root^2     = " + e);
        assertTrue("root^2 <= a ", e.compareTo(b) <= 0);
        c = c.sum(BigInteger.ONE);
        f = c.multiply(c);
        //System.out.println("(root+1)^2 = " + f);
        assertTrue("(root+1)^2 >= a ", f.compareTo(b) >= 0);
    }


    /**
     * Test root.
     */
    public void testRoot() {
        BigInteger a, b, d, e, f;
        a = BigInteger.ONE;

        b = a.random(47).abs();
        //System.out.println("\nb          = " + b);
        //System.out.println("bitsize(b) = " + b.val.bitLength());
        for (int n = 2; n < 8; n++) {
            d = Roots.root(b, n);
            //System.out.println(n+"-th root  = " + d);
            e = Power.positivePower(d, n);
            //System.out.println("root^"+n+"     = " + e);
            assertTrue("root^" + n + " <= a " + (b.subtract(e)), e.compareTo(b) <= 0);
            d = d.sum(BigInteger.ONE);
            f = Power.positivePower(d, n);
            //System.out.println("(root+1)^"+n+" = " + f);
            assertTrue("(root+1)^" + n + " >= a ", f.compareTo(b) >= 0);
        }
    }


    /**
     * Test root decimal.
     */
    public void testRootDecimal() {
        BigDecimal a, b, d, e;
        a = BigDecimal.ONE;
        BigRational eps = new BigRational(1, 10).power(BigDecimal.DEFAULT_PRECISION - 2);
        BigDecimal epsd = new BigDecimal(eps);

        b = a.random(17).abs();
        //System.out.println("\nb         = " + b);
        //System.out.println("ulp(b)     = " + b.val.ulp());
        for (int n = 1; n < 8; n++) {
            d = Roots.root(b, n);
            //System.out.println(n+"-th root = " + d);
            e = Power.positivePower(d, n);
            //System.out.println("root^"+n+"    = " + e);
            if (b.compareTo(e) == 0) {
                assertTrue("root^" + n + " == b: " + e, b.compareTo(e) == 0);
                continue;
            }
            BigDecimal r = b.subtract(e).abs().divide(b.abs().sum(e.abs()));
            assertTrue("root(a,n)**n == a: " + r, r.compareTo(epsd) <= 0);
        }
    }


    /**
     * Test root decimal.
     */
    public void test2RootDecimal() {
        BigDecimal a, b, c, d;
        a = BigDecimal.ZERO;
        b = Roots.sqrt(a);
        assertTrue("sqrt(0) == 0: " + b, b.isZERO());

        a = BigDecimal.ONE;
        b = Roots.sqrt(a);
        assertTrue("sqrt(1) == 1: " + b, b.isONE());

        a = new BigDecimal("4");
        b = Roots.sqrt(a);
        //b = Roots.root(a,2);
        c = b.multiply(b);
        assertTrue("sqrt(4)*sqrt(4) == 4: " + a.subtract(c), a.compareTo(c) == 0);
        //System.out.println("DEFAULT_PRECISION = " + BigDecimal.DEFAULT_PRECISION);

        a = new BigDecimal("0.5");
        b = Roots.sqrt(a);
        //b = Roots.root(a,2);
        c = b.multiply(b);
        //System.out.println("a = " + a + ", sqrt(a) = " + b + ", b^2 = " + c);
        assertTrue("sqrt(0.5)*sqrt(0.5) == 0.5: " + a.subtract(c), a.compareTo(c) == 0);
        assertTrue("sqrt(0.5)*sqrt(0.5) == 0.5: " + b, a.compareTo(c) == 0);

        a = a.random(5).abs();
        b = Roots.sqrt(a);
        //b = Roots.root(a,2);
        c = b.multiply(b);
        //System.out.println("a = " + a + ", sqrt(a) = " + b + ", b^2 = " + c);
        BigDecimal eps = new BigDecimal("0.1").power(BigDecimal.DEFAULT_PRECISION - 2);
        d = a.subtract(c).abs().divide(a.abs().sum(BigDecimal.ONE));
        assertTrue("sqrt(a)*sqrt(a) == a: " + d, d.compareTo(eps) <= 0);
    }


    /**
     * Test root complex decimal.
     */
    public void testRootDecimalComplex() {
        BigDecimalComplex a, b, c, d, e;
        a = BigDecimalComplex.ZERO;
        b = Roots.sqrt(a);
        assertTrue("sqrt(0) == 0: " + b, b.isZERO());

        a = BigDecimalComplex.ONE;
        b = Roots.sqrt(a);
        assertTrue("sqrt(1) == 1: " + b, b.isONE());

        a = BigDecimalComplex.ONE.negate();
        b = Roots.sqrt(a);
        d = b.multiply(b);
        //System.out.println("a = " + a + ", b = " + b + ", d = " + d);
        assertTrue("sqrt(-1) == I: " + b, b.isIMAG());
        assertTrue("sqrt(-1)*sqrt(-1) == -1: " + a + ", b = " + b, a.compareTo(d) == 0);

        b = BigDecimalComplex.I;
        c = Roots.sqrt(b);
        d = c.multiply(c);
        //System.out.println("b = " + b + ", c = " + c + ", d = " + d);
        assertTrue("sqrt(b)*sqrt(b) == b: " + c + ", b = " + b, b.compareTo(d) == 0);

        b = a.fromInteger(4);
        c = Roots.sqrt(b);
        d = BigDecimalComplex.ONE.sum(BigDecimalComplex.ONE);
        //System.out.println("b = " + b + ", c = " + c + ", d = " + d);
        assertTrue("sqrt(4) == 2: " + c, c.compareTo(d) == 0);

        b = b.multiply(BigDecimalComplex.I);
        c = Roots.sqrt(b);
        d = c.multiply(c);
        //System.out.println("b = " + b + ", c = " + c + ", d = " + d);
        assertTrue("sqrt(b)*sqrt(b) == b: " + c + ", b = " + b, b.compareTo(d) == 0);

        b = a.random(5);
        c = b.norm();
        d = b.multiply(b.conjugate());
        assertTrue("norm(b) == b*b^: b-d = " + c.subtract(d), c.compareTo(d) == 0);

        BigRational eps = new BigRational(1, 10).power(BigDecimal.DEFAULT_PRECISION - 1);
        //System.out.println("eps = " + eps + ", epsd = " + new BigDecimal(eps));
        BigDecimal epsd = new BigDecimal(eps);
        BigDecimal dd;

        //System.out.println("b = " + b + ", c = " + c);
        //c = b.norm();
        d = b.abs();
        e = d.multiply(d);
        dd = e.re.subtract(c.re).abs().divide(e.re.abs().sum(c.re.abs()));
        //System.out.println("dd = " + dd + ", d = " + d + ", e = " + e);
        assertTrue("abs()*abs() == norm(): " + dd, dd.compareTo(epsd) <= 0);
    }


    /**
     * Test root rational.
     */
    public void test2RootRational() {
        BigRational a, b, c, d;
        a = BigRational.ZERO;
        b = Roots.sqrt(a);
        assertTrue("sqrt(0) == 0: " + b, b.isZERO());

        a = BigRational.ONE;
        b = Roots.sqrt(a);
        assertTrue("sqrt(1) == 1: " + b, b.isONE());

        a = BigRational.ONE.negate();
        try {
            b = Roots.sqrt(a);
            fail("sqrt(-1) illegal: " + b);
        } catch (ArithmeticException e) {
            // pass
        }

        a = new BigRational("4");
        b = Roots.sqrt(a);
        c = b.multiply(b);
        assertTrue("sqrt(4)*sqrt(4) == 4: " + a.subtract(c), a.compareTo(c) == 0);
        BigRational eps = new BigRational(1, 10).power(BigDecimal.DEFAULT_PRECISION - 1);
        //System.out.println("eps = " + eps + ", epsd = " + new BigDecimal(eps));

        a = new BigRational("0.5");
        b = Roots.sqrt(a);
        c = b.multiply(b);
        //System.out.println("a = " + a + ", sqrt(a) = " + b + ", b^2 = " + c);
        d = a.subtract(c).abs().divide(a.abs().sum(c.abs()));
        //System.out.println("d = " + d + ", dd = " + new BigDecimal(d));
        assertTrue("sqrt(0.5)*sqrt(0.5) == 0.5: " + c, d.compareTo(eps) <= 0);

        a = a.random(5).abs();
        b = Roots.sqrt(a);
        c = b.multiply(b);
        //System.out.println("a = " + a + ", sqrt(a) = " + b + ", b^2 = " + c);
        d = a.subtract(c).abs().divide(a.abs().sum(c.abs()));
        //System.out.println("d = " + d + ", dd = " + new BigDecimal(d));
        assertTrue("sqrt(0.5)*sqrt(0.5) == 0.5: " + c, d.compareTo(eps) <= 0);
    }


    /**
     * Test root/norm complex.
     */
    public void test2NormComplex() {
        BigComplex a, b;
        a = BigComplex.ZERO;
        b = a.abs();
        assertTrue("abs(0) == 0: " + b, b.isZERO());

        a = BigComplex.ONE;
        b = a.abs();
        assertTrue("abs(1) == 1: " + b, b.isONE());

        a = BigComplex.ONE.negate();
        b = a.abs();
        assertTrue("abs(-1): " + b, b.isONE());

        BigRational eps = new BigRational(1, 10).power(BigDecimal.DEFAULT_PRECISION - 1);
        //System.out.println("eps = " + eps); // + ", epsd = " + new BigDecimal(eps));

        BigRational r, s, t;
        a = a.random(5);
        b = a.abs();
        //System.out.println("a = " + a + ", b = " + b);
        r = b.multiply(b).re;
        s = a.multiply(a.conjugate()).re;
        //System.out.println("r = " + r + ", s = " + s);
        t = r.subtract(s).abs().divide(r.abs().sum(s.abs()));
        //System.out.println("t = " + t + ", eps = " + eps);
        assertTrue("abs()*abs() == norm(): " + b, t.compareTo(eps) <= 0);
    }


    /**
     * Test root/norm quaternion.
     */
    public void test2NormQuaternion() {
        BigQuaternion a, b;
        BigQuaternionRing fac = new BigQuaternionRing();
        a = fac.ZERO;
        b = a.abs();
        assertTrue("abs(0) == 0: " + b, b.isZERO());

        a = fac.ONE;
        b = a.abs();
        assertTrue("abs(1) == 1: " + b, b.isONE());

        a = fac.ONE.negate();
        b = a.abs();
        assertTrue("abs(-1): " + b, b.isONE());

        BigRational eps = new BigRational(1, 10).power(BigDecimal.DEFAULT_PRECISION - 1);
        //System.out.println("eps = " + eps); // + ", epsd = " + new BigDecimal(eps));

        BigRational r, s, t;
        a = fac.random(5);
        b = a.abs();
        //System.out.println("\na = " + a + ", b = " + b);
        r = b.multiply(b).re;
        s = a.multiply(a.conjugate()).re;
        //System.out.println("r = " + r + ", s = " + s);
        t = r.subtract(s).abs().divide(r.abs().sum(s.abs()));
        //System.out.println("t = " + t + ", eps = " + eps);

        assertTrue("sqrt(x)*sqrt(x): " + b, t.compareTo(eps) <= 0);
    }


    /**
     * Test root/norm octonion.
     */
    public void test2NormOctonion() {
        BigOctonion a, b;
        BigQuaternionRing fac = new BigQuaternionRing();
        BigOctonion ofac = new BigOctonion(fac);

        a = ofac.getZERO();
        b = a.abs();
        assertTrue("abs(0) == 0: " + b, b.isZERO());

        a = ofac.getONE();
        b = a.abs();
        assertTrue("abs(1) == 1: " + b, b.isONE());

        a = ofac.getONE().negate();
        b = a.abs();
        assertTrue("abs(-1): " + b, b.isONE());

        BigRational eps = new BigRational(1, 10).power(BigDecimal.DEFAULT_PRECISION - 1);
        //System.out.println("eps = " + eps); // + ", epsd = " + new BigDecimal(eps));

        BigRational r, s, t;
        a = ofac.random(5);
        b = a.abs();
        //System.out.println("\na = " + a + ", b = " + b);
        r = b.multiply(b).or.re;
        s = a.multiply(a.conjugate()).or.re;
        //System.out.println("r = " + r + ", s = " + s);
        t = r.subtract(s).abs().divide(r.abs().sum(s.abs()));
        //System.out.println("t = " + t + ", eps = " + eps);

        assertTrue("sqrt(x)*sqrt(x): " + b, t.compareTo(eps) <= 0);
    }


    /**
     * Test continued fraction.
     */
    public void testContinuedFraction() {
        BigRational fac = BigRational.ONE;
        BigRational x = fac.random(35);
        //x = fac.parse("5/12");
        //x = fac.parse("-1");

        List<BigInteger> cf = ArithUtil.continuedFraction(x);
        //System.out.println("cf(" + x + ") = " + cf);

        BigRational a = ArithUtil.continuedFractionApprox(cf);
        //System.out.println("a = " + a);
        assertEquals("a = approx(cf(a)): ", x, a);
    }

}
