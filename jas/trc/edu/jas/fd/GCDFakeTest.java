/*
 * $Id$
 */

package edu.jas.fd;


import java.util.ArrayList;
import java.util.List;


import edu.jas.arith.BigRational;
import edu.jas.gb.SolvableGroebnerBaseAbstract;
import edu.jas.gb.SolvableGroebnerBaseSeq;
import edu.jas.kern.ComputerThreads;
import edu.jas.poly.GenPolynomial;
import edu.jas.poly.GenSolvablePolynomial;
import edu.jas.poly.GenSolvablePolynomialRing;
import edu.jas.poly.PolyUtil;
import edu.jas.poly.PolynomialList;
import edu.jas.poly.RecSolvablePolynomial;
import edu.jas.poly.RecSolvablePolynomialRing;
import edu.jas.poly.RelationGenerator;
import edu.jas.poly.TermOrder;
import edu.jas.poly.WeylRelationsIterated;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;


/**
 * GCD Fake PRS algorithm tests with JUnit. <b>Note:</b> not in sync with
 * implementation.
 * @author Heinz Kredel
 */

public class GCDFakeTest extends TestCase {


    /**
     * main.
     */
    public static void main(String[] args) {
        junit.textui.TestRunner.run(suite());
        ComputerThreads.terminate();
    }


    /**
     * Constructs a <CODE>GCDFakeTest</CODE> object.
     * @param name String.
     */
    public GCDFakeTest(String name) {
        super(name);
    }


    /**
     */
    public static Test suite() {
        TestSuite suite = new TestSuite(GCDFakeTest.class);
        return suite;
    }


    GreatestCommonDivisorAbstract<BigRational> fd;


    TermOrder to = new TermOrder(TermOrder.INVLEX);


    GenSolvablePolynomialRing<BigRational> dfac;


    //GenSolvablePolynomialRing<GenPolynomial<BigRational>> rfac;
    RecSolvablePolynomialRing<BigRational> rfac;


    GenSolvablePolynomial<BigRational> a, b, a0, b0, c, d, e;


    GenSolvablePolynomial<GenPolynomial<BigRational>> ar, br, cr, dr, er, ar0, br0;


    int rl = 4;


    int kl = 2;


    int ll = 2;


    int el = 3;


    float q = 0.25f;


    @Override
    protected void setUp() {
        a = b = c = d = e = null;
        ar = br = cr = dr = er = null;
        String[] vars = new String[] { "a", "b", "c", "d" };
        BigRational cf = new BigRational(1);
        fd = new GreatestCommonDivisorFake<BigRational>(cf);
        dfac = new GenSolvablePolynomialRing<BigRational>(cf, rl, to, vars);
        RelationGenerator<BigRational> wl = new WeylRelationsIterated<BigRational>();
        dfac.addRelations(wl);
        rfac = (RecSolvablePolynomialRing<BigRational>) dfac.recursive(1);
        //System.out.println("dfac = " + dfac);
    }


    @Override
    protected void tearDown() {
        a = b = c = d = e = null;
        ar = br = cr = dr = er = null;
        fd = null;
        dfac = null;
        rfac = null;
    }


    /**
     * Test base gcd simple.
     */
    public void testBaseGcdFake() {
        String[] uvars = new String[] { "x" };
        dfac = new GenSolvablePolynomialRing<BigRational>(new BigRational(1), 1, to, uvars);
        for (int i = 0; i < 3; i++) {
            a = dfac.random(kl * (i + 2), ll + 2 * i, el + 2, q);
            b = dfac.random(kl * (i + 1), ll + i, el + 2, q);
            c = dfac.random(kl * (i + 1), ll + 1, el + 1, q);
            c = c.multiply(dfac.univariate(0));
            if (c.isZERO()) {
                // skip for this turn
                continue;
            }
            //a = fd.basePrimitivePart(a);
            //b = fd.basePrimitivePart(b);
            //c = (GenSolvablePolynomial<BigRational>) fd.basePrimitivePart(c).abs();
            //System.out.println("a  = " + a);
            //System.out.println("b  = " + b);
            //System.out.println("c  = " + c);

            a = a.multiply(c);
            b = b.multiply(c);

            d = fd.leftBaseGcd(a, b);
            e = (GenSolvablePolynomial<BigRational>) PolyUtil.<BigRational> baseSparsePseudoRemainder(d, c);
            //System.out.println("d  = " + d);
            //System.out.println("c  = " + c);
            assertTrue("c | gcd(ac,bc) " + e, e.isZERO() || d.isONE());

            e = (GenSolvablePolynomial<BigRational>) PolyUtil.<BigRational> baseSparsePseudoRemainder(a, d);
            //System.out.println("e = " + e);
            assertTrue("gcd(a,b) | a " + e, e.isZERO());

            e = (GenSolvablePolynomial<BigRational>) PolyUtil.<BigRational> baseSparsePseudoRemainder(b, d);
            //System.out.println("e = " + e);
            assertTrue("gcd(a,b) | b " + e, e.isZERO());
        }
    }


    /**
     * Test univariate recursive left gcd simple.
     */
    @SuppressWarnings("cast")
    public void testRecursiveLeftGCDFake() {
        String[] vars = new String[] { "a", "b" };
        dfac = new GenSolvablePolynomialRing<BigRational>(new BigRational(1), to, vars);
        RelationGenerator<BigRational> wl = new WeylRelationsIterated<BigRational>();
        dfac.addRelations(wl);
        //System.out.println("dfac = " + dfac.toScript());
        rfac = (RecSolvablePolynomialRing<BigRational>) dfac.recursive(1);
        //System.out.println("rfac = " + rfac.toScript());

        RecSolvablePolynomialRing<BigRational> rrfacTemp = rfac;
        GenSolvablePolynomialRing<GenPolynomial<BigRational>> rrfac = rfac;

        GenSolvablePolynomialRing<BigRational> rcfac = (GenSolvablePolynomialRing<BigRational>) rfac.coFac;
        SolvableQuotientRing<BigRational> qfac = new SolvableQuotientRing<BigRational>(rcfac);
        QuotSolvablePolynomialRing<BigRational> rqfac = new QuotSolvablePolynomialRing<BigRational>(qfac,
                        rrfac);
        List<GenSolvablePolynomial<GenPolynomial<BigRational>>> rl = rrfacTemp.coeffTable.relationList();
        List<GenPolynomial<GenPolynomial<BigRational>>> rlc = PolynomialList
                        .<GenPolynomial<BigRational>> castToList(rl);
        rqfac.polCoeff.coeffTable.addRelations(rlc);
        //System.out.println("rrfac  = " + rrfac.toScript());
        //System.out.println("rcfac  = " + rcfac.toScript());
        //System.out.println("qfac   = " + qfac.toScript());
        //System.out.println("rqfac  = " + rqfac.toScript());

        //kl = 3; 
        ll = 3;
        el = 3;

        ar = rfac.random(kl, ll, el + 1, q);
        br = rfac.random(kl, ll, el, q);
        cr = rfac.random(kl, ll, el, q);
        ////cr = (RecSolvablePolynomial<BigRational>) cr.abs();
        cr = (RecSolvablePolynomial<BigRational>) PolyUtil.<BigRational> monic(cr);
        //cr = (RecSolvablePolynomial<BigRational>) fd.recursivePrimitivePart(cr).abs();
        //cr = rfac.getONE();
        //cr = rfac.parse("a+b+c+d");

        //ar = rfac.parse("( ( -31/19 )  ) b^3 - ( 781/260 a - 641/372  )");
        //br = rfac.parse("( ( -1/5 ) a - 1/4  ) b^2 - 11/12  b - ( 47/17 a + 29/30  )");
        //cr = rfac.parse(" ( a + 9/8  ) b + ( 285/208 a + 191/280  )");

        //ar = rfac.parse("b^3 - ( a )");
        //br = rfac.parse("( a ) b^2 - 1/2 b");
        //cr = rfac.parse("b + ( a )");

        //ar = rfac.parse("( 2/23 a - 1/2  ) b^3 + 617/672  b^2 - ( 5 a + 307/154  )");
        //br = rfac.parse("( ( -673/330 )  ) b - ( 2/5 a - 566969/1651860  )");
        //cr = rfac.parse("( a - 2287945/213324  )");

        //ar = rfac.parse("( b^2 + 1/2 )");
        //br = rfac.parse("( a^2 b - ( a - 1/3 ) )");
        //cr = rfac.parse("( b + a - 1/5 )");

        //System.out.println("ar = " + ar);
        //System.out.println("br = " + br);
        //System.out.println("cr = " + cr);

        if (cr.isZERO()) {
            cr = rfac.getONE();
        }
        //ar = cr.multiply(ar);
        //br = cr.multiply(br);
        ar = ar.multiply(cr);
        br = br.multiply(cr);
        //System.out.println("ar = " + ar);
        //System.out.println("br = " + br);

        dr = fd.leftRecursiveUnivariateGcd(ar, br);
        //System.out.println("cr = " + cr);
        //System.out.println("dr = " + dr);

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveSparsePseudoRemainder(dr, cr);
        //System.out.println("er = " + er);
        assertTrue("c | gcd(ac,bc) " + er, er.isZERO() || dr.isONE());

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveSparsePseudoRemainder(ar, dr);
        //System.out.println("er = " + er);
        assertTrue("gcd(a,b) | a " + er, er.isZERO());

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveSparsePseudoRemainder(br, dr);
        //System.out.println("er = " + er);
        assertTrue("gcd(a,b) | b " + er, er.isZERO());

        //if (true) return;
        GenSolvablePolynomial<SolvableQuotient<BigRational>> ap, bp, cp, dp, gp, ep, apm, bpm, cpm, dpm, gpm;
        ap = FDUtil.<BigRational> quotientFromIntegralCoefficients(rqfac, ar);
        bp = FDUtil.<BigRational> quotientFromIntegralCoefficients(rqfac, br);
        cp = FDUtil.<BigRational> quotientFromIntegralCoefficients(rqfac, cr);
        dp = FDUtil.<BigRational> quotientFromIntegralCoefficients(rqfac, dr);
        apm = ap.monic();
        bpm = bp.monic();
        cpm = cp.monic();
        dpm = dp.monic();
        //System.out.println("ap  = " + ap);
        //System.out.println("apm = " + apm);
        //System.out.println("bp  = " + bp);
        //System.out.println("bpm = " + bpm);
        //System.out.println("cp  = " + cp);
        //System.out.println("cpm = " + cpm);
        //System.out.println("dp  = " + dp);
        //System.out.println("dpm = " + dpm);
        assertTrue("", apm.leadingBaseCoefficient().isONE());
        assertTrue("", bpm.leadingBaseCoefficient().isONE());
        assertTrue("", cpm.leadingBaseCoefficient().isONE());
        assertTrue("", dpm.leadingBaseCoefficient().isONE());

        GreatestCommonDivisorAbstract<SolvableQuotient<BigRational>> fdq = new GreatestCommonDivisorFake<SolvableQuotient<BigRational>>(
                        qfac);
        gp = fdq.leftBaseGcd(ap, bp);
        gpm = gp.monic();
        //System.out.println("gp  = " + gp);
        //System.out.println("gpm = " + gpm);
        assertTrue("", gpm.leadingBaseCoefficient().isONE());

        ep = FDUtil.<SolvableQuotient<BigRational>> leftBaseSparsePseudoRemainder(gp, dp);
        //System.out.println("ep  = " + ep);
        assertTrue("c | gcd(ac,bc): " + ep, ep.isZERO());

        ep = FDUtil.<SolvableQuotient<BigRational>> leftBaseSparsePseudoRemainder(ap, gp);
        //System.out.println("ep  = " + ep);
        assertTrue("gcd(ac,bc)| ac): " + ep, ep.isZERO());

        ep = FDUtil.<SolvableQuotient<BigRational>> leftBaseSparsePseudoRemainder(bp, gp);
        //System.out.println("ep  = " + ep);
        assertTrue("gcd(ac,bc)| bc): " + ep, ep.isZERO());
    }


    /**
     * Test univariate recursive right gcd simple.
     */
    @SuppressWarnings("cast")
    public void testRecursiveRightGCDFake() {
        String[] vars = new String[] { "a", "b" };
        dfac = new GenSolvablePolynomialRing<BigRational>(new BigRational(1), to, vars);
        RelationGenerator<BigRational> wl = new WeylRelationsIterated<BigRational>();
        dfac.addRelations(wl);
        //System.out.println("dfac = " + dfac.toScript());
        rfac = (RecSolvablePolynomialRing<BigRational>) dfac.recursive(1);
        //System.out.println("rfac = " + rfac.toScript());

        RecSolvablePolynomialRing<BigRational> rrfacTemp = rfac;
        GenSolvablePolynomialRing<GenPolynomial<BigRational>> rrfac = rfac;

        GenSolvablePolynomialRing<BigRational> rcfac = (GenSolvablePolynomialRing<BigRational>) rfac.coFac;
        SolvableQuotientRing<BigRational> qfac = new SolvableQuotientRing<BigRational>(rcfac);
        QuotSolvablePolynomialRing<BigRational> rqfac = new QuotSolvablePolynomialRing<BigRational>(qfac,
                        rrfac);
        List<GenSolvablePolynomial<GenPolynomial<BigRational>>> rl = rrfacTemp.coeffTable.relationList();
        List<GenPolynomial<GenPolynomial<BigRational>>> rlc = PolynomialList
                        .<GenPolynomial<BigRational>> castToList(rl);
        rqfac.polCoeff.coeffTable.addRelations(rlc);
        //System.out.println("rrfac  = " + rrfac.toScript());
        //System.out.println("rcfac  = " + rcfac.toScript());
        //System.out.println("qfac   = " + qfac.toScript());
        //System.out.println("rqfac  = " + rqfac.toScript());

        //kl = 3; 
        int ll = 3;
        int el = 3;

        ar = rfac.random(kl, ll, el + 1, q);
        br = rfac.random(kl, ll, el, q);
        cr = rfac.random(kl, ll, el, q);
        ////cr = (RecSolvablePolynomial<BigRational>) cr.abs();
        cr = (RecSolvablePolynomial<BigRational>) PolyUtil.<BigRational> monic(cr);
        //cr = (RecSolvablePolynomial<BigRational>) fd.recursivePrimitivePart(cr).abs();
        //cr = rfac.getONE();

        //System.out.println("ar = " + ar);
        //System.out.println("br = " + br);
        //System.out.println("cr = " + cr);

        if (cr.isZERO()) {
            cr = rfac.getONE();
        }
        ar = cr.multiply(ar);
        br = cr.multiply(br);
        //ar = ar.multiply(cr);
        //br = br.multiply(cr);
        //System.out.println("ar = " + ar);
        //System.out.println("br = " + br);

        dr = fd.rightRecursiveUnivariateGcd(ar, br);
        //System.out.println("cr = " + cr);
        //System.out.println("dr = " + dr);

        //er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveRightPseudoQuotient(dr, cr);
        //System.out.println("dr/cr = " + er);

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveRightSparsePseudoRemainder(dr,
                        cr);
        //System.out.println("er = " + er);
        assertTrue("c | gcd(ac,bc) " + er, er.isZERO() || dr.isONE());

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveRightSparsePseudoRemainder(ar,
                        dr);
        //System.out.println("er = " + er);
        assertTrue("gcd(a,b) | a " + er, er.isZERO());

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveRightSparsePseudoRemainder(br,
                        dr);
        //System.out.println("er = " + er);
        assertTrue("gcd(a,b) | b " + er, er.isZERO());
    }


    /**
     * Test arbitrary recursive gcd simple.
     */
    @SuppressWarnings("cast")
    public void testArbitraryRecursiveGCDFake() {
        String[] cvars = new String[] { "a", "b" };
        String[] vars = new String[] { "c" };
        dfac = new GenSolvablePolynomialRing<BigRational>(new BigRational(1), to, cvars);
        RelationGenerator<BigRational> wl = new WeylRelationsIterated<BigRational>();
        dfac.addRelations(wl);
        //System.out.println("dfac = " + dfac.toScript());
        rfac = new RecSolvablePolynomialRing<BigRational>(dfac, to, vars);
        //System.out.println("rfac = " + rfac.toScript());

        //kl = 3; ll = 2;
        int el = 2;

        ar0 = rfac.random(kl, ll, el + 1, q);
        br0 = rfac.random(kl, ll, el, q);
        cr = rfac.random(kl, ll, el, q);

        //ar = rfac.parse("a + b c^2 ");
        //br = rfac.parse("( a^2 - 1/3  ) c - 1/4");
        //cr = rfac.parse("(b - 1/2 a^2) c");
        //ar = rfac.parse("( 2/11 a * b^2 + 11/24 b - 11/6 a^2 )");
        //br = rfac.parse("( 14/13 b^2 - 1/69 )");
        //cr = rfac.parse("c + 33/133 a");
        //ar0 = rfac.parse("( a * b^2 + 1/2 b - 1/6 a^2 )");
        //br0 = rfac.parse("( b^2 - 1/5 )");
        //cr = rfac.parse("c + 3/13 a");

        //cr = (RecSolvablePolynomial<BigRational>) fd.recursivePrimitivePart(cr).abs();
        cr = (RecSolvablePolynomial<BigRational>) cr.monic();
        if (cr.isZERO()) {
            cr = rfac.getONE();
        }
        //System.out.println("ar = " + ar);
        //System.out.println("br = " + br);
        //System.out.println("cr = " + cr);

        // left gcd
        ar = ar0.multiply(cr);
        br = br0.multiply(cr);
        //System.out.println("ar = " + ar);
        //System.out.println("br = " + br);

        dr = fd.leftRecursiveGcd(ar, br);
        //System.out.println("cr = " + cr);
        //System.out.println("dr = " + dr);

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveSparsePseudoRemainder(dr, cr);
        //System.out.println("er = " + er);
        assertTrue("c | gcd(ac,bc) " + er, er.isZERO() || dr.isONE());

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveSparsePseudoRemainder(ar, dr);
        //System.out.println("er = " + er);
        assertTrue("gcd(ac,bc) | ac " + er, er.isZERO());

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveSparsePseudoRemainder(br, dr);
        //System.out.println("er = " + er);
        assertTrue("gcd(ac,bc) | bc " + er, er.isZERO());


        // right gcd
        ar = cr.multiply(ar0);
        br = cr.multiply(br0);
        //System.out.println("ar = " + ar);
        //System.out.println("br = " + br);

        dr = fd.rightRecursiveGcd(ar, br);
        //System.out.println("cr = " + cr);
        //System.out.println("dr = " + dr);

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveRightSparsePseudoRemainder(dr,
                        cr);
        //System.out.println("er = " + er);
        assertTrue("c | gcd(ca,cb) " + er, er.isZERO() || dr.isONE());

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveRightSparsePseudoRemainder(ar,
                        dr);
        //System.out.println("er = " + er);
        assertTrue("gcd(ca,cb) | ca " + er, er.isZERO());

        er = (RecSolvablePolynomial<BigRational>) FDUtil.<BigRational> recursiveRightSparsePseudoRemainder(br,
                        dr);
        //System.out.println("er = " + er);
        assertTrue("gcd(ca,cb) | cb " + er, er.isZERO());
    }


    /**
     * Test full gcd simple, 4 variables.
     */
    public void testGCDFake() {
        String[] vars = new String[] { "a", "b", "c", "d" };
        //String[] vars = new String[] { "a", "b" };
        dfac = new GenSolvablePolynomialRing<BigRational>(new BigRational(1), to, vars);
        RelationGenerator<BigRational> wl = new WeylRelationsIterated<BigRational>();
        //RelationGenerator<BigRational> wl = new WeylRelations<BigRational>();
        dfac.addRelations(wl);
        //System.out.println("dfac = " + dfac.toScript());

        //kl = 3; 
        ll = 4;
        el = 4;

        //a = dfac.random(kl, ll, el, q);
        //b = dfac.random(kl, ll, el, q);
        //c = dfac.random(kl, ll, el, q);
        //c = c.multiply(dfac.univariate(0));

        a0 = dfac.parse("b^3 - 1/6 + d");
        b0 = dfac.parse("b + 3 a^2 + d");
        //b = dfac.parse("( -1/2 ) b + 3 a^2 + d");
        //c = dfac.parse("(a - 5 b) + c + d");
        //ok: c = dfac.parse("(a - b) c");
        //c = dfac.parse("(a - b) + c + d ");
        //c = dfac.parse("(a - b) + c");
        //c = dfac.parse("(a - b) + b^2");
        c = dfac.parse("c - a - b");
        //c = dfac.parse("d - c - b - a");
        //c = dfac.parse("(a - b) + d");
        //c = dfac.parse("b + d");
        //c = dfac.parse("a + d");

        //a = dfac.parse("2 b^3 * d^2 + 2/3 a + 3/2");
        //b = dfac.parse("2/3 d + 1/2 a^3 + 3/4");
        //c = dfac.parse("c^2 * d - 1/2 a^3 * d + 5/4 d");

        //c = (GenSolvablePolynomial<BigRational>) fd.primitivePart(c).abs();
        c = c.monic();
        if (c.isZERO()) {
            c = dfac.getONE();
        }
        //System.out.println("a = " + a);
        //System.out.println("b = " + b);
        //System.out.println("c = " + c);

        a = a0.multiply(c);
        b = b0.multiply(c);
        //System.out.println("a = " + a);
        //System.out.println("b = " + b);
        //System.out.println("c = " + c);


        List<GenSolvablePolynomial<BigRational>> L = new ArrayList<GenSolvablePolynomial<BigRational>>();
        L.add(a);
        L.add(b);
        SolvableGroebnerBaseAbstract<BigRational> sbb = new SolvableGroebnerBaseSeq<BigRational>();

        // left 
        List<GenSolvablePolynomial<BigRational>> Llgb = sbb.leftGB(L);
        //System.out.println("leftGB = " + Llgb);
        //List<GenSolvablePolynomial<BigRational>> Ltgb = sbb.twosidedGB(L);
        //System.out.println("twosidedGB = " + Ltgb);

        d = fd.leftGcd(a, b);
        //System.out.println("gb = " + Llgb);
        //System.out.println("c  = " + c);
        //System.out.println("d  = " + d);
        assertTrue("d in leftGB", sbb.sred.leftNormalform(Llgb, d).isZERO() || d.isONE());

        e = FDUtil.<BigRational> leftBaseSparsePseudoRemainder(d, c);
        //System.out.println("e = " + e);
        assertTrue("c | gcd(ac,bc): " + e, e.isZERO() || d.isONE());

        e = FDUtil.<BigRational> leftBaseSparsePseudoRemainder(a, c);
        //System.out.println("e = " + e);
        assertTrue("c | ac: " + e, e.isZERO());
        e = FDUtil.<BigRational> leftBaseSparsePseudoRemainder(b, c);
        //System.out.println("e = " + e);
        assertTrue("c | bc: " + e, e.isZERO());

        e = FDUtil.<BigRational> leftBaseSparsePseudoRemainder(a, d);
        //System.out.println("e = " + e);
        //e = FDUtil.<BigRational> divideRightPolynomial(a,d);
        //System.out.println("e = " + e);
        assertTrue("gcd(a,b) | a: " + e, e.isZERO());

        e = FDUtil.<BigRational> leftBaseSparsePseudoRemainder(b, d);
        //System.out.println("e = " + e);
        //e = FDUtil.<BigRational> divideRightPolynomial(b,d);
        //System.out.println("e = " + e);
        assertTrue("gcd(a,b) | b: " + e, e.isZERO());


        // right
        a = c.multiply(a0);
        b = c.multiply(b0);
        //System.out.println("a = " + a);
        //System.out.println("b = " + b);
        //System.out.println("c = " + c);

        //List<GenSolvablePolynomial<BigRational>> Lrgb = sbb.rightGB(L); // too long
        //System.out.println("rightGB = " + Lrgb);
        //List<GenSolvablePolynomial<BigRational>> Ltgb = sbb.twosidedGB(L);
        //System.out.println("twosidedGB = " + Ltgb);

        d = fd.rightGcd(a, b);
        //System.out.println("gb = " + Llgb);
        //System.out.println("c  = " + c);
        //System.out.println("d  = " + d);

        e = FDUtil.<BigRational> rightBaseSparsePseudoRemainder(d, c);
        //System.out.println("e = " + e);
        assertTrue("c | gcd(ac,bc): " + e, e.isZERO() || d.isONE());

        e = FDUtil.<BigRational> rightBaseSparsePseudoRemainder(a, c);
        //System.out.println("e = " + e);
        assertTrue("c | ac: " + e, e.isZERO());
        e = FDUtil.<BigRational> rightBaseSparsePseudoRemainder(b, c);
        //System.out.println("e = " + e);
        assertTrue("c | bc: " + e, e.isZERO());

        e = FDUtil.<BigRational> rightBaseSparsePseudoRemainder(a, d);
        //System.out.println("e = " + e);
        //e = FDUtil.<BigRational> divideRightPolynomial(a,d);
        //System.out.println("e = " + e);
        assertTrue("gcd(a,b) | a: " + e, e.isZERO());

        e = FDUtil.<BigRational> rightBaseSparsePseudoRemainder(b, d);
        //System.out.println("e = " + e);
        //e = FDUtil.<BigRational> divideRightPolynomial(b,d);
        //System.out.println("e = " + e);
        assertTrue("gcd(a,b) | b: " + e, e.isZERO());
    }

}
