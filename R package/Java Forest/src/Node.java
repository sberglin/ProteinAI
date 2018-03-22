import java.util.ArrayList;

public class Node {

	private ArrayList<Node> children;		// child nodes
	private String level;					// level of parent variable in node
	private ArrayList<Integer> parentVars;	// variables used to split in parents
	
	// Constructor for terminal node
	public Node(String level, ArrayList<Integer> parentVars) {
		this.parentVars = parentVars;
		this.level = level;
//		var = -1;	// No splitting variable needed
	}
	
	// Constructor for non-terminal node
	public Node(int var, String level, ArrayList<Node> children,
			ArrayList<Integer> parentVars) {
		this.parentVars = parentVars;
		this.level = level;
//		this.var = var;
		this.children = children;
	}
	
	public ArrayList<Integer> getParentVars() {
		return parentVars;
	}
	
	public String getLevel() {
		return this.level;
	}
	
	public ArrayList<Node> getChildren() {
		return this.children;
	}
	
	// n is number of indents
	public void print(int n) {
		
		String indent = " - ";	// String used to display indent
		
		// Handling the possibility of a null parent variable array list
		String var;
		if (parentVars == null) { var = "null"; } 
		else { var = Integer.toString(parentVars.get(0)); }
		
		// Printing indents
		for (int i = 1; i <= n; i++) { System.out.print(indent); }
		// Printing node
		System.out.print("(" + var + "=" + this.getLevel() + ")");
	}
	
	// n is number of indents
	public void printVerbose(int n) {
		
		// Printing node
		this.print(n);
		
		// Recursively printing children
		for (Node child : this.getChildren()) {
			child.printVerbose(n+1);
		}
	}
	
}
