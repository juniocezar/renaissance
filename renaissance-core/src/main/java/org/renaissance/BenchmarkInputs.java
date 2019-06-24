package org.renaissance;
// JINN Project
// Author: Junio

import java.util.Vector;

public class BenchmarkInputs {
	private int numThreads;
	private int numRatings;
	private static BenchmarkInputs singleton = null;
	private static boolean enableDebug = true;

	private BenchmarkInputs () {
		this.numThreads = Runtime.getRuntime().availableProcessors();
		this.numRatings = 20000;
	} 

	private static void init() {
		if (singleton == null) {
			singleton = new BenchmarkInputs();
		}
	}

	public static String[] parse (String[] args) {
		init();
		Vector<String> vecArgs = new Vector<String>();
		for (int i = 0; i < args.length; i++) {
			String token = args[i];
			//
			// assumes the following arg is not the last one in the cmd line
			if (token.equals("--als-threads")) {	
				singleton.numThreads = Integer.parseInt(args[++i]);
			} else if (token.equals("--als-ratings")) {
				singleton.numRatings = Integer.parseInt(args[++i]);
			} else {
				vecArgs.add(token);
			}
		}
		debug ("Processing workload with " + singleton.numThreads + " threads");		
		return vecArgs.toArray(new String[vecArgs.size()]);
	}    

    private static void debug (String msg) {
      if (! enableDebug) return;
      else {
        System.out.println("\t:: DEBUG :: " + msg);
      }
    }



	public static int getNumThreads () {
		init();
		return singleton.numThreads;
	}

	public static int getNumRatings () {
		init();
		return singleton.numRatings;
	}


}
