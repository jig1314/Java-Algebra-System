/*
 * $Id$
 */

package edu.jas.util;

import java.io.IOException;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager; 

//import edu.unima.ky.parallel.ChannelFactory;
//import edu.unima.ky.parallel.SocketChannel;


/**
 * ExecutableServer tests with JUnit.
 * @author Heinz Kredel
 */

public class ExecutableServerTest extends TestCase {

/**
 * main.
 */
   public static void main (String[] args) {
          junit.textui.TestRunner.run( suite() );
   }

/**
 * Constructs a <CODE>ExecutableServerTest</CODE> object.
 * @param name String.
 */
   public ExecutableServerTest(String name) {
          super(name);
   }

/**
 * suite.
 */ 
 public static Test suite() {
     TestSuite suite= new TestSuite(ExecutableServerTest.class);
     return suite;
   }

   private static final String host = "localhost";
   private static final int port = ChannelFactory.DEFAULT_PORT;

   private ExecutableServer es;
   private ChannelFactory cf;

   protected void setUp() {
       es = new ExecutableServer(port);
       es.init();
       cf = new ChannelFactory();
   }

   protected void tearDown() {
       es.terminate();
       es = null;
       cf.terminate();
       cf = null;
   }


/**
 * Tests if the ExecutableServer could be started and terminated.
 */
 public void testExecutableServer1() {
     assertTrue("should never fail", true );
   }


/**
 * Tests if the ExecutableServer can execute a RemoteExecutable.
 */
 public void testExecutableServer2() {
     RemoteExecutable e1 = new Executable("2");
     try {
         SocketChannel sc = cf.getChannel(host,port);
         sc.send( e1 );
         Object o = sc.receive();
         assertTrue("o:String", o instanceof String);
         assertEquals("o==done", (String)o, ExecutableServer.DONE );
         sc.close();
     } catch (IOException e) {
         e.printStackTrace();
         fail("IOException");
     } catch (ClassNotFoundException e) {
         e.printStackTrace();
         fail("ClassNotFoundException");
     }
   }


/**
 * Tests if the ExecutableServer can execute more RemoteExecutable.
 */
 public void testExecutableServer3() {
     RemoteExecutable e1 = new Executable("3");
     int numloops = 1; // can be changed in ExecutableServer.run()
     Object o;
     try {
         SocketChannel sc = cf.getChannel(host,port);
         for (int i = 0; i < numloops; i++ ) {
             sc.send( e1 );
             o = sc.receive();
             assertTrue("o:String", o instanceof String);
             assertEquals("o==done", (String)o, ExecutableServer.DONE );
         }
         sc.close();
     } catch (IOException e) {
         e.printStackTrace();
         fail("IOException");
     } catch (ClassNotFoundException e) {
         e.printStackTrace();
         fail("ClassNotFoundException");
     }
   }


/**
 * Tests if the ExecutableServer can execute a RemoteExecutable.
 */
 public void testExecutableServer4() {
     RemoteExecutable e1 = null; 
     SocketChannel sc = null;
     Object o;
     try {
         for (int i = 0; i < 4; i++ ) {
             e1 = new Executable("4-"+i);
             sc = cf.getChannel(host,port);

             sc.send( e1 );
             o = sc.receive();
             assertTrue("o:String", o instanceof String);
             assertEquals("o==done", (String)o, ExecutableServer.DONE );

             e1 = null;
             sc.close();
             sc = null;
         }
     } catch (IOException e) {
         e.printStackTrace();
         fail("IOException");
     } catch (ClassNotFoundException e) {
         e.printStackTrace();
         fail("ClassNotFoundException");
     }
   }

}


/**
 * Unit Test Class which implements interface RemoteExecutable.
 */

class Executable implements RemoteExecutable {

    private static final Logger logger = LogManager.getLogger(Executable.class);

    private String param = null;

    /**
     * Executable.
     * @param param String.
     */
    public Executable(String param) {
        this.param = param;
    }

    /**
     * run.
     */
    public void run() {
        logger.debug(this + " has been run");
    }

    /**
     * toString.
     */
    public String toString() {
        return "Executable(" + param + ")";
    }

}
