/*
 * $Id$
 */

package edu.jas.gbufd;


import java.util.ArrayList;
import java.util.List;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;


import edu.jas.arith.BigInteger;
import edu.jas.kern.ComputerThreads;
import edu.jas.gb.SolvableGroebnerBaseAbstract;
import edu.jas.poly.GenPolynomial;
import edu.jas.poly.GenPolynomialRing;
import edu.jas.poly.GenSolvablePolynomial;
import edu.jas.poly.GenSolvablePolynomialRing;
import edu.jas.poly.PolynomialList;
import edu.jas.poly.RelationGenerator;
import edu.jas.poly.RelationTable;
import edu.jas.poly.TermOrder;
import edu.jas.poly.WeylRelations;


/**
 * Solvable Groebner base pseudo sequential tests with JUnit.
 * @author Heinz Kredel
 */

public class SolvableGroebnerBasePseudoRecSeqTest extends TestCase {




    /**
     * main.
     */
    public static void main(String[] args) {
        junit.textui.TestRunner.run(suite());
        ComputerThreads.terminate();
    }


    /**
     * Constructs a <CODE>SolvableGroebnerBasePseudoRecSeqTest</CODE> object.
     * @param name String.
     */
    public SolvableGroebnerBasePseudoRecSeqTest(String name) {
        super(name);
    }


    /**
     * suite.
     */
    public static Test suite() {
        TestSuite suite = new TestSuite(SolvableGroebnerBasePseudoRecSeqTest.class);
        return suite;
    }


    GenSolvablePolynomial<GenPolynomial<BigInteger>> a, b, c, d, e;


    List<GenSolvablePolynomial<GenPolynomial<BigInteger>>> L;


    PolynomialList<GenPolynomial<BigInteger>> F, G;


    GenSolvablePolynomialRing<GenPolynomial<BigInteger>> ring;


    SolvableGroebnerBaseAbstract<GenPolynomial<BigInteger>> sbb;


    BigInteger cfac;


    TermOrder tord;


    //RelationTable<GenPolynomial<BigInteger>> table;


    int rl = 4; //4; //3; 


    int kl = 2;


    int ll = 5;


    int el = 3;


    float q = 0.3f; //0.4f


    @Override
    protected void setUp() {
        cfac = new BigInteger(9);
        tord = new TermOrder();
        String[] cvars = new String[] { "a", "b" };
        String[] vars = new String[] { "x", "y" };
        GenPolynomialRing<BigInteger> cring;
          cring = new GenPolynomialRing<BigInteger>(cfac, tord, cvars);
        ring = new GenSolvablePolynomialRing<GenPolynomial<BigInteger>>(cring, tord, vars);
        //table = ring.table;
        a = b = c = d = e = null;
        sbb = new SolvableGroebnerBasePseudoRecSeq<BigInteger>(cring);

        a = ring.random(kl, ll, el, q);
        b = ring.random(kl, ll, el, q);
        c = ring.random(kl, ll-1, el-1, q);
        d = ring.random(kl, ll-1, el-1, q);
        e = d; //ring.random(kl, ll, el, q );
    }


    @Override
    protected void tearDown() {
        a = b = c = d = e = null;
        ring = null;
        tord = null;
        //table = null;
        cfac = null;
        sbb = null;
    }


    /**
     * Test sequential GBase.
     */
    public void testSequentialGBase() {
        L = new ArrayList<GenSolvablePolynomial<GenPolynomial<BigInteger>>>();

        L.add(a);
        L = sbb.leftGB(L);
        //System.out.println("L = " + L);
        assertTrue("isLeftGB( { a } )", sbb.isLeftGB(L));

        L.add(b);
        L = sbb.leftGB(L);
        //System.out.println("L = " + L);
        assertTrue("isLeftGB( { a, b } )", sbb.isLeftGB(L));

        L.add(c); 
        L = sbb.leftGB(L);
        //System.out.println("L = " + L);
        assertTrue("isLeftGB( { a, b, c } )", sbb.isLeftGB(L));

        L.add(d);
        L = sbb.leftGB(L);
        //System.out.println("L = " + L);
        assertTrue("isLeftGB( { a, b, c, d } )", sbb.isLeftGB(L));

        L.add(e);
        L = sbb.leftGB(L);
        //System.out.println("L = " + L);
        assertTrue("isLeftGB( { a, b, c, d, e } )", sbb.isLeftGB(L));
    }


    /**
     * Test Weyl sequential GBase.
     */
    public void testWeylSequentialGBase() {
        //int rloc = 4;
        //ring = new GenSolvablePolynomialRing<BigInteger>(cfac,rloc);

        RelationGenerator<GenPolynomial<BigInteger>> wl = new WeylRelations<GenPolynomial<BigInteger>>();
        wl.generate(ring);
        //table = ring.table;

        a = ring.random(kl, ll, el, q);
        b = ring.random(kl, ll, el, q);
        c = ring.random(kl, ll-1, el-1, q);
        d = ring.random(kl, ll-1, el-1, q);
        e = d; //ring.random(kl, ll, el, q );

        L = new ArrayList<GenSolvablePolynomial<GenPolynomial<BigInteger>>>();

        L.add(a);
        L = sbb.leftGB(L);
        assertTrue("isLeftGB( { a } )", sbb.isLeftGB(L));

        L.add(b);
        //System.out.println("L = " + L.size() );
        L = sbb.leftGB(L);
        assertTrue("isLeftGB( { a, b } )", sbb.isLeftGB(L));

        L.add(c);
        L = sbb.leftGB(L);
        assertTrue("isLeftGB( { a, b, c } )", sbb.isLeftGB(L));

        L.add(d);
        L = sbb.leftGB(L);
        assertTrue("isLeftGB( { a, b, c, d } )", sbb.isLeftGB(L));

        L.add(e);
        L = sbb.leftGB(L);
        //System.out.println("L = " + L);
        assertTrue("isLeftGB( { a, b, c, d, e } )", sbb.isLeftGB(L));
    }


    /**
     * Test sequential twosided GBase.
     */
    public void testSequentialTSGBase() {
        L = new ArrayList<GenSolvablePolynomial<GenPolynomial<BigInteger>>>();

        L.add(a);
        L = sbb.twosidedGB(L);
        //System.out.println("L = " + L);
        assertTrue("isTwosidedGB( { a } )", sbb.isTwosidedGB(L));

        L.add(b);
        L = sbb.twosidedGB(L);
        //System.out.println("L = " + L);
        assertTrue("isTwosidedGB( { a, b } )", sbb.isTwosidedGB(L));

        L.add(c);
        L = sbb.twosidedGB(L);
        //System.out.println("L = " + L);
        assertTrue("isTwosidedGB( { a, b, c } )", sbb.isTwosidedGB(L));

        L.add(d);
        L = sbb.twosidedGB(L);
        //System.out.println("L = " + L);
        assertTrue("isTwosidedGB( { a, b, c, d } )", sbb.isTwosidedGB(L));

        L.add(e);
        L = sbb.twosidedGB(L);
        //System.out.println("L = " + L.size() );
        //System.out.println("L = " + L);
        assertTrue("isTwosidedGB( { a, b, c, d, e } )", sbb.isTwosidedGB(L));
    }


    /**
     * Test Weyl sequential twosided GBase is always 1.
     */
    public void testWeylSequentialTSGBase() {
        //int rloc = 4;
        //ring = new GenSolvablePolynomialRing<BigInteger>(cfac,rloc);

        RelationGenerator<GenPolynomial<BigInteger>> wl = new WeylRelations<GenPolynomial<BigInteger>>();
        wl.generate(ring);
        //table = ring.table;

        a = ring.random(kl, ll, el, q);
        b = ring.random(kl, ll, el, q);
        c = ring.random(kl, ll-1, el-1, q);
        d = ring.random(kl, ll-1, el-1, q);
        e = d; //ring.random(kl, ll, el, q );

        L = new ArrayList<GenSolvablePolynomial<GenPolynomial<BigInteger>>>();

        L.add(a);
        //System.out.println("La = " + L );
        L = sbb.twosidedGB(L);
        //System.out.println("L = " + L );
        assertTrue("isTwosidedGB( { a } )", sbb.isTwosidedGB(L));

        L.add(b);
        L = sbb.twosidedGB(L);
        //System.out.println("L = " + L );
        assertTrue("isTwosidedGB( { a, b } )", sbb.isTwosidedGB(L));

        L.add(c);
        L = sbb.twosidedGB(L);
        //System.out.println("L = " + L );
        assertTrue("isTwosidedGB( { a, b, c } )", sbb.isTwosidedGB(L));

        L.add(d);
        L = sbb.twosidedGB(L);
        //System.out.println("L = " + L );
        assertTrue("isTwosidedGB( { a, b, c, d } )", sbb.isTwosidedGB(L));

        L.add(e);
        L = sbb.twosidedGB(L);
        //System.out.println("L = " + L);
        assertTrue("isTwosidedGB( { a, b, c, d, e } )", sbb.isTwosidedGB(L));
    }


    /*
     * Test sequential extended GBase.
    public void testSequentialExtendedGBase() {
        L = new ArrayList<GenSolvablePolynomial<GenPolynomial<BigInteger>>>();

        SolvableExtendedGB<GenPolynomial<BigInteger>> exgb;

        L.add(a);
        //System.out.println("L = " + L );

        exgb = sbb.extLeftGB( L );
        //System.out.println("exgb = " + exgb );
        assertTrue("isLeftGB( { a } )", sbb.isLeftGB(exgb.G) );
        assertTrue("isLeftRmat( { a } )", sbb.isLeftReductionMatrix(exgb) );

        L.add(b);
        //System.out.println("L = " + L );
        exgb = sbb.extLeftGB( L );
        //System.out.println("exgb = " + exgb );
        assertTrue("isLeftGB( { a, b } )", sbb.isLeftGB(exgb.G) );
        assertTrue("isLeftRmat( { a, b } )", sbb.isLeftReductionMatrix(exgb) );

        L.add(c);
        exgb = sbb.extLeftGB( L );
        //System.out.println("exgb = " + exgb );
        assertTrue("isLeftGB( { a, b, c } )", sbb.isLeftGB(exgb.G) );
        assertTrue("isLeftRmat( { a, b, c } )", sbb.isLeftReductionMatrix(exgb) );

        L.add(d);
        exgb = sbb.extLeftGB( L );
        //System.out.println("exgb = " + exgb );
        assertTrue("isLeftGB( { a, b, c, d } )", sbb.isLeftGB(exgb.G) );
        assertTrue("isLeftRmat( { a, b, c, d } )", sbb.isLeftReductionMatrix(exgb) );

        L.add(e);
        exgb = sbb.extLeftGB( L );
        //System.out.println("exgb = " + exgb );
        assertTrue("isLeftGB( { a, b, c, d, e } )", sbb.isLeftGB(exgb.G) );
        assertTrue("isLeftRmat( { a, b, c, d, e } )", sbb.isLeftReductionMatrix(exgb) );
    }
     */


    /*
     * Test Weyl sequential extended GBase.
    public void testWeylSequentialExtendedGBase() {
        //int rloc = 4;
        //ring = new GenSolvablePolynomialRing<BigInteger>(cfac,rloc);

        RelationGenerator<GenPolynomial<BigInteger>> wl = new WeylRelations<GenPolynomial<BigInteger>>();
        wl.generate(ring);
        //table = ring.table;

        a = ring.random(kl, ll, el, q );
        b = ring.random(kl, ll, el, q );
        c = ring.random(kl, ll, el, q );
        d = ring.random(kl, ll, el, q );
        e = d; //ring.random(kl, ll, el, q );

        SolvableExtendedGB<BigInteger> exgb;

        L = new ArrayList<GenSolvablePolynomial<GenPolynomial<BigInteger>>>();

        L.add(a);
        exgb = sbb.extLeftGB( L );
        // System.out.println("exgb = " + exgb );
        assertTrue("isLeftGB( { a } )", sbb.isLeftGB(exgb.G) );
        assertTrue("isRmat( { a } )", sbb.isLeftReductionMatrix(exgb) );

        L.add(b);
        //System.out.println("L = " + L.size() );
        exgb = sbb.extLeftGB( L );
        //System.out.println("exgb = " + exgb );
        assertTrue("isLeftGB( { a, b } )", sbb.isLeftGB(exgb.G) );
        assertTrue("isRmat( { a, b } )", sbb.isLeftReductionMatrix(exgb) );

        L.add(c);
        exgb = sbb.extLeftGB( L );
        //System.out.println("exgb = " + exgb );
        assertTrue("isLeftGB( { a, b, c } )", sbb.isLeftGB(exgb.G) );
        assertTrue("isRmat( { a, b, c } )", sbb.isLeftReductionMatrix(exgb) );

        L.add(d);
        exgb = sbb.extLeftGB( L );
        //System.out.println("exgb = " + exgb );
        assertTrue("isLeftGB( { a, b, c, d } )", sbb.isLeftGB(exgb.G) );
        assertTrue("isRmat( { a, b, c, d } )", sbb.isLeftReductionMatrix(exgb) );

        L.add(e);
        exgb = sbb.extLeftGB( L );
        //System.out.println("exgb = " + exgb );
        assertTrue("isLeftGB( { a, b, c, d, e } )", sbb.isLeftGB(exgb.G) );
        assertTrue("isRmat( { a, b, c, d, e } )", sbb.isLeftReductionMatrix(exgb) );
    }
     */

}
