import java.util.ArrayList;

public class Testing {

	public static void main(String[] args) {
		tPrint();
	}
	
	// Testing Print Method
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
	
	// TODO Testing printVerbose method
	
	// Testing Split Method
	public static void tSplit() {
		// Testing Split Method
		Node t = new Node(null, null);
		int var = 1;
		String[][] variables = { {"1", "2", "3"},
								 {"1", "2", "3"} };
	}

}
