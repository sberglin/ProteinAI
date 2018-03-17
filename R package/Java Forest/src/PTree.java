import java.util.Arrays;
//import java.util.Collections;
import org.apache.commons.math3.stat.inference.ChiSquareTest;
import java.util.ArrayList;

public class PTree {

	Node root;
	
	// TESTING
	public static void main(String[] args) {
		ChiSquareTest x = new ChiSquareTest();
		
		System.out.println("Done");
	}

	/**
	 * Constructor for PTree
	 * 
	 * @param predictors A 2d string array of predictor variables. In order to
	 * accommodate for either block or amino acid data, their entries are
	 * assumed to be Strings.
	 * @param response A 1d array of the binary responses. In order to be as
	 * flexible as possible, they are assumed to be Strings.
	 * @param variables A 2D array, dictating the possible values
	 * each variable can take as Strings. Since we are dealing with 
	 * exclusively sequence data, variable "names" do not apply. Thus, we 
	 * "name" each variable as its position in the sequence, starting from
	 * zero.
	 */
	public PTree(String[][] predictors, String[] response, String[][] variables) {
		
		// Split the root node
	}
	
	/** 
	 * Splits a given node on a given variable.
	 * 
	 * @param t
	 * @param var
	 * @param variables
	 */
	private void split(Node t, int var, String[][] variables) {
		
		// New List of Children
		ArrayList<Node> children = new ArrayList<Node>();
		
		// Creating Children
		for (String i : variables[var]) {
			// Adding new parent variables
			int[] newParentVars = Arrays.copyOf(t.getParentVars(),
					t.getParentVars().length + 1);
			newParentVars[newParentVars.length - 1] = t.getVar();
			// Adding child
			children.add(new Node(i, newParentVars));
		}
		
		// Replacing t with same node with children
		t = new Node(var, t.getLevel(), children, t.getParentVars());
	}
	
	/**
	 * Finds the strongest variable to split on, measured by a Chi-squared
	 * test.
	 * 
	 * @param t
	 * @return
	 */
	private String findVar(Node t, String[][] nodeData, String[][] variables) {
		
		// Gathering variables to test
		ArrayList<Integer> vars = null;
		for (int i = 0; i <= variables.length; i++) {
			// If variable has not be used to split parents, add it to test
			if (Arrays.asList(t.getParentVars()).contains(i)) {
				continue;
			} else {
				vars.add(Integer.valueOf(i));
			}
		}
		
		// Array to store calculated p-values
		Double[] pvals = new Double[vars.size()];
		
		// For each variable, perform chi-squared test
		for (int var : vars) {
			// Perform chi squared test for each variable present in data
		}	
		
		// Find minimum p-value
		Double min = Math.findMin(pvals);
		
		// If the p-value is small enough, split on that variable
//		if (min < 0) {
//		}
		// Else, return the node itself
//		else {
//		}
		
		return null;
}
	
	private String[] findInteraction(Node t) {
		return null;
	}
}

