package junk;

import java.util.ArrayList;
import java.util.Arrays;

public class Testing {

	public  static void main(String[] args) throws Exception {
		
	}
	
	public static void tPrint() {
		Node t = new Node(null, null);
		t.print(0);
		System.out.println(" (Correct: (null=null) )");
		
		ArrayList<Integer> a = new ArrayList<Integer>();
		a.add(2);
		Node x = new Node("0", a);
		x.print(1);
		System.out.println(" (Correct:  - (2=0) )");
		
	}
	
	public static void tPrintVerbose() {
		
		// Terminal nodes
		Node a = new Node("1", new ArrayList<Integer>(Arrays.asList(2, 4)));
		Node b = new Node("2", new ArrayList<Integer>(Arrays.asList(2, 4)));
		Node c = new Node("2", new ArrayList<Integer>(Arrays.asList(4)));
		
		// Non-terminal nodes
		ArrayList<Node> childrenD = new ArrayList<Node>();
		childrenD.add(a); childrenD.add(b);
		Node d = new Node("1", childrenD,
				new ArrayList<Integer>(Arrays.asList(4)));
		ArrayList<Node> childrenE = new ArrayList<Node>();
		childrenE.add(d); childrenE.add(c);
		Node e = new Node(null, childrenE, null);
		
		// Printing
		e.printVerbose(0);
		
		// Correct Output
		System.out.println("(Correct)");
		System.out.println("( Var null = null)\n - ( Var 4 = 1)\n"
				+ " - - ( Var 2 = 1)\n - - ( Var 2 = 2)\n - ( Var 4 = 2)");
	}
	
	public static void tSplit() throws Exception {
		
		// Setup
		PTree tree = new PTree();
		Node t = new Node(null, null);
		int varA = 1;
		int varB = 0;
		String[][] variables = { {"1", "2", "3"},
								 {"1", "2", "3"} };
		
		// Splitting and recording output
		PTree.testSplit(t, varA, variables);
		PTree.testSplit(t.getChildren().get(0), varB, variables);
		t.printVerbose(0);
		
		// Displaying Correct Output
		System.out.println("\n(Correct)\n ( Var null = null)\n - ( Var 1 = 1)"
				+ "\n-  - ( Var 0 = 1)\n -  - ( Var 0 = 2)\n -  - ( Var 0 = 3)"
				+ "\n - ( Var 1 = 2)\n - ( Var 1 = 3)");
	}

	public static void tFindVar() {
		
	}
}
