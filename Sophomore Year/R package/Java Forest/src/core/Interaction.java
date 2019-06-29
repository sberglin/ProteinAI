package core;

import java.util.ArrayList;

import weka.core.Attribute;

public class Interaction {

	// 2 Attributes
	private Attribute a;
	private Attribute b;
	
	// Type
	private final int type;
	
	// Type of interactions
	public static final int NOMINAL_NOMINAL = 0;
	public static final int NUMERIC_NUMERIC = 1;
	public static final int NUMERIC_NOMINAL = 2;
	
	// Constructor
 	public Interaction(Attribute a, Attribute b) {
		this.a = a;
		this.b = b;
		type = findType(a, b);
	}
 	
 	// Find types of interactions
 	private int findType(Attribute a, Attribute b) {
 		if (a.type() == Attribute.NOMINAL) {
 			if (b.type() == Attribute.NOMINAL) {
 				return 0;
 			} else {
 				return 2;
 			}
 		} else {
 			if (b.type() == Attribute.NUMERIC) {
 				return 1;
 			} else {
 				return 2;
 			}
 		}
 	}
 	
 	// Access to attributes
 	public ArrayList<Attribute> getAttributes() {
 		ArrayList<Attribute> out = new ArrayList<Attribute>();
 		out.add(a);
 		out.add(b);
 		return out;
 	}
 	
 	// Access to type of interaction
 	public int getType() {
 		return this.type;
 	}
}
