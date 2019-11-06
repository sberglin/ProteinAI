package core;

import weka.core.Instance;
import weka.core.Instances;
import weka.core.Attribute;
import weka.core.DenseInstance;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

public class InteractableInstances {

	// Name of interactions
	String name;
	
	// Original Data
	Instances data;		// Do I really need this?
	
	// Interactions
	ArrayList<Interaction> inters;
	
	// Interaction Dataset
	Instances interactionData;
	
	public InteractableInstances(String name, Instances data, ArrayList<Interaction> inters) {
		this.name = name;
		this.data = data;
		this.inters = inters;
		this.interactionData = interactionInstances();
	}
	
/**
 * Make second 'Instances' with new attributes based on Interactions.
 * 
 * @return new interaction data as Instances.
 */
	public Instances interactionInstances() {
		
		Attribute a, b;				// Attributes for specific interaction
		String interName;			// Name of specific interaction
		List<String> interLevels;	// Attributes levels for specific interaction
		
		
		// Specifying new attributes for new interaction data
		ArrayList<Attribute> newAtts = new ArrayList<Attribute>();
		
		for (Interaction inter : inters) {
			// Creating new interaction attribute
			a = inter.getAttributes().get(0);
			b = inter.getAttributes().get(1);
			// New name
			interName = a.name() + "_" + b.name();
			// New levels
			interLevels = cartesianProduct(a.enumerateValues(), b.enumerateValues());
			// Adding the attribute
			newAtts.add(new Attribute(interName, interLevels));
		}
		
		// Creating new Instances for interaction data
		Instances interactionData = new Instances(this.name, newAtts, data.numInstances());
		
		// Helpers for iterating through instances
		Instance x;
		Enumeration<Attribute> eAtt;
		Enumeration<Object> eLevels;
		Attribute interAtt;
		Instance newInterInst;
		
		// Iterating through instances
		for (int i = 0; i < data.numInstances(); i++) {
			x = data.get(i);
			newInterInst = new DenseInstance(interactionData.numAttributes());
			eAtt = interactionData.enumerateAttributes();
			while (eAtt.hasMoreElements()) {
				interAtt = eAtt.nextElement();
				
				newInterInst.setValue(interAtt, );	
			}
			
			interactionData.add(newInterInst);
		}
		
		return interactionData;
	}
	
	private String findInterLevel(Instance inst, Attribute interAtt) {
		
		// Indicator of success
		boolean foundLevel = false;
		
		// Levels (of i) of each attribute in the interaction
		String[] levels;
		int c = 0; 	// Counter for adding levels
		int i = 0;	// Counter for instance attributes
		
		// Attribute enumerator (from instance)
		Enumeration<Attribute> e = inst.enumerateAttributes();
		Attribute instanceAtt;
		
		String name = interAtt.name();
		String[] attNames = name.split("_");
		
		while (e.hasMoreElements()) {
			instanceAtt = e.nextElement();
			if (instanceAtt.name().equals(attNames[0]) || 
					instanceAtt.name().equals(attNames[1])) {
				levels[c] = inst.;
			}
			i++;
		}
		
		
		
		
		
		return null;
	}
	
	/**
	 * Find cartesian product of values. This is used for creating new instances.
	 * 
	 * @param a First enumeration
	 * @param b Second enumeration
	 * @return The product as a List<String>
	 */
	public List<String> cartesianProduct(Enumeration<Object> a, Enumeration<Object> b) {
		
		List<String> out = new ArrayList<String>();
		
		// NOTE: This assumes that a.nextElement().toString() returns the level of a as a String
		while (a.hasMoreElements()) {
			while (b.hasMoreElements()) {
				out.add(a.nextElement().toString() +"_"+ b.nextElement().toString());
			}
		}
		
		return out;
	}
}
