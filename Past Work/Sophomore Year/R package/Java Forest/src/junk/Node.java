package junk;

import java.util.ArrayList;

public class Node {

	private ArrayList<Node> children;		// child nodes
	private String level;					// level of parent variable in node
	private ArrayList<Integer> parentVars;	// variables used to split in parents
											//  change this to a single integer
	private int parentVar;
	
	// Constructor for terminal node
	public Node(String level, ArrayList<Integer> parentVars) {
		this.parentVars = parentVars;
		this.level = level;
	}
	
	// Constructor for non-terminal node
	public Node(String level, ArrayList<Node> children, 
			ArrayList<Integer> parentVars) {
		this.parentVars = parentVars;
		this.level = level;
		this.children = children;
	}
	
	public ArrayList<Integer> getParentVars() {
		// return COPY of parent variables (not actual parent variables)
		if (this.parentVars == null) {
			return null;
		} else {
			return new ArrayList<Integer>(parentVars);
		}
		
	}
	
	public String getLevel() {
		return this.level;
	}
	
	public ArrayList<Node> getChildren() {
		return this.children;
	}
	
	public boolean isLeaf() {
		return this.getChildren() == null;
	}
	
	public void changeChildren(ArrayList<Node> children) {
		this.children = children;
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
		System.out.println("( Var " + var + " = " + this.getLevel() + ")");
	}
	
	// n is number of indents
	public void printVerbose(int n) {
		
		// Printing node
		this.print(n);
		
		// Recursively printing existent children
		if (!this.isLeaf()) {
			for (Node child : this.getChildren()) {
				child.printVerbose(n+1);
			}
		}
		
	}
	
}
