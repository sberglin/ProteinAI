package junk;

import java.util.Arrays;
import java.util.Collections;
import org.apache.commons.math3.stat.inference.ChiSquareTest;
import java.util.ArrayList;

public class PTree {

	Node root;
	
	/**
	 * Constructor for a PTree without data.
	 * 
	 * Note: used exclusively for testing purposes
	 */
	public PTree() {
		root = new Node(null, null);
	}
	
	/**
	 * Constructor for PTree with data
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
	public PTree(String[][] predictors, int[] response, String[][] variables) {
		
		// Create root node
		root = new Node(null, null);
		
		// Using entire dataset to grow (indices from 1 to n)
		ArrayList<Integer> nodeData = new ArrayList<Integer>();
		for (int i = 0; i < predictors.length; i++) {
			nodeData.add(i);
		}
		
		// Grow the root node
		try {
			grow(root, predictors, response, variables, nodeData);
		} catch (Exception e) {
			System.out.println("Error in growing tree");
		}
		
	}
	
	/** 
	 * Splits a given node on a given variable.
	 * 
	 * @param t Node to split
	 * @param var Variable to split on
	 * @param variables Structure of data
	 */
	private static void split(Node t, int var, String[][] variables) throws Exception{
		
		// Error if attempting to split an already split node
		if (t.getChildren() != null) {
			System.out.println("ERROR: Attempted to split an already splitted node");
			throw new Exception();
		}
		
		// New List of Children
		ArrayList<Node> children = new ArrayList<Node>();
		ArrayList<Integer> newParentVars;
		
		// Creating Children
		for (String i : variables[var]) {
			// Adding new parent variables
			newParentVars = t.getParentVars();
			// If no parent variables, start the list
			if (newParentVars == null) {
				newParentVars = new ArrayList<Integer>();
				newParentVars.add(var);
			// Else, just add to it
			} else {
				newParentVars.add(0, var);
			}
			// Adding child
			children.add(new Node(i, newParentVars));
		}
		
		// Replacing t with same node with children
		t.changeChildren(children);
	}
	
	/**
	 * Finds the strongest variable to split on, measured by a Chi-squared
	 * test.
	 * 
	 * Note: If the best variable does not split the data "well enough,"
	 * returns -1 to indicate that no variable is appropriate.
	 * 
	 * @param t
	 * @param nodeData indices of data that is "present" in node t. Since the
	 * tree is splitting data, each node cannot "see" all of the data. Thus,
	 * we consider a subset of the data parameterized by indices.
	 * @param variables Structure of data
	 * @return
	 */
	private static int findVar(Node t, ArrayList<Integer> nodeData, String[][] predictors,
			int[] response, String[][] variables) {
		
		ArrayList<Integer> vars = new ArrayList<Integer>();	// List of vars to test
		long[][] conTab = null; 								// Contingency table for data
		
		// Gathering variables to test
		for (int i = 0; i <= variables.length; i++) {
			// If variable has not be used to split parents, add it to test
			if (Arrays.asList(t.getParentVars()).contains(i)) {
				continue;
			} else {
				vars.add(Integer.valueOf(i));
			}
		}
		
		
		Double[] pvals = new Double[vars.size()];	// Array to store calculated p-values
		int y = -1;		// value to store each observation's response
		String x;		// value to store level of variable observed
		ChiSquareTest chi = new ChiSquareTest();
		
		// For each variable, perform chi-squared test
		for (int var : vars) {
			// Gathering levels of the variable
			ArrayList<String> levels = new ArrayList<String>(Arrays.asList(variables[var]));
			// Creating contingency table
			conTab = new long[2][variables[var].length];	// response x variable level
			// Populating contingency table
			for (int i : nodeData) {
				y = response[i];				// Response
				x = predictors[i][var];		// Level of variable observed
				conTab[y][levels.indexOf(x)]++;
			}
			// Perform chi squared test and store result
			pvals[var] = chi.chiSquareTest(conTab);
		}	
		
		// Find minimum p-value
		double minP = Collections.min(Arrays.asList(pvals));
		
		// If the p-value is small enough at a bonferroni corrected level,
		// split on that variable
		if (minP < (0.05 / vars.size())) {
			return Arrays.asList(minP).indexOf(minP);
		}
		// Else, return -1 (no proper variable found)
		else {
			return -1;
		}
}
	
	/**
	 * Create and grow children for a given node.
	 * 
	 * @param t The node to grow from
	 * @return The grown Node.
	 */
	private Node grow(Node t, String[][] predictors, int[] response,
			String[][] variables, ArrayList<Integer> nodeData) throws Exception {
		
		// Find variable to split this node on
		int var = findVar(t, nodeData, predictors, response, variables);
		
		// Indices of data to be used in growing each child
		ArrayList<Integer> childData;
		
		String[][] newVars;
		
		// If the variable split is good enough,
		if (var >= 0) {
			// Split node on that variable
			split(t, var, variables);
			// Do same on each child
			for (Node child : t.getChildren()) {
				// Finding appropriate indices to be passed to the child
				childData = new ArrayList<Integer>();
				for (int i : nodeData) {
					// If observation i has level of the child, add it to nodeData
					if (predictors[i][var].equals(child.getLevel())) {
						childData.add(i);
					}
				}
				// Adjusting variables to indicate that var has already been used
				newVars = removeVariable(var, variables);
				grow(child, predictors, response, newVars, childData);
			}
		}

		// Return the 'grown' node
		return t;
	}
	
	/**
	 * Removes a given variable from the "available" variables for splitting.
	 * That is, once a split is done on a variable, it is no longer considered
	 * in Chi-squared tests at the children nodes since they will all have the
	 * same value.
	 * 
	 * @param var The variable to remove (as int)
	 * @param variables The 2D array dictating the structure of the variables
	 * @return
	 */
	private String[][] removeVariable(int var, String[][] variables) {
		
		// New 2D array to hold variable structure
		String[][] newVars = new String[variables.length - 1][];
		
		// Re-populating it only if the variable is not the one in question
		for (int i = 0; i <= variables.length - 1; i++) {
			if (i == var) { 
				continue; 
			} else {
				newVars[i] = variables[i];
			}
		}
		return newVars;
	}
	
	/**
	 * Figure out how this is or should be done
	 * 
	 * @param t
	 * @return
	 */
 	private String[] findInteraction(Node t) {
		return null;
	}
	
	public void print(PTree tree) {
		root.printVerbose(0);
	}
	
	// For testing
	public static void testSplit(Node t, int var, String[][] variables) throws Exception {
		split(t, var, variables);
	}
}

