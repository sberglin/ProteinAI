import java.util.ArrayList;

public class Node {

	private ArrayList<Node> children;	// child nodes
	private int var;						// variable that was used to split
	private String level;				// level of parent variable in node
	private int[] parentVars;			// variables used to split in parents
	
	// Constructor for terminal node
	public Node(String level, int[] parentVars) {
		this.parentVars = parentVars;
		this.level = level;
		var = -1;	// No splitting variable needed
	}
	
	// Constructor for non-terminal node
	public Node(int var, String level, ArrayList<Node> children, int[] parentVars) {
		this.parentVars = parentVars;
		this.level = level;
		this.var = var;
		this.children = children;
	}
	
	public int[] getParentVars() {
		return parentVars;
	}
	
	public String getLevel() {
		return this.level;
	}
	
	public int getVar() {
		return var;
	}
	
	public ArrayList<Node> getChildren() {
		return this.children;
	}
	
}
