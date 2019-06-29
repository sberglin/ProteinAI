package core;

import java.util.List;

import weka.core.Attribute;
import weka.core.Instances;

@SuppressWarnings("serial")
public class InteractionAttribute extends Attribute {

	// Attributes that interact
	private final Attribute a;
	private final Attribute b;
	
	// Attribute levels
	private final String aLevel;
	private final String bLevel;
	
	public InteractionAttribute(Attribute a, Attribute b) {
		
		
		
		String attributeName;
		List<String> attributeValues;
		
		attributeName = a.name() + "_" + b.name();
		
		super(attributeName, attributeValues);
		a = null;
		b = null;
		aLevel = null;
		bLevel = null;
	}
	
	

	

}
