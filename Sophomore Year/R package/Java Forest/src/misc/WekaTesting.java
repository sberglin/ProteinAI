package misc;

import java.util.Random;
import java.awt.BorderLayout;
import java.io.File;

import classifiers.CJ48;
import weka.classifiers.evaluation.Evaluation;
import weka.classifiers.trees.J48;
import weka.core.converters.CSVLoader;
import weka.core.Drawable;
import weka.core.Instances;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.NumericToNominal;
import weka.gui.treevisualizer.PlaceNode2;
import weka.gui.treevisualizer.TreeVisualizer;
import weka.attributeSelection.ChiSquaredAttributeEval;

public class WekaTesting {

	public static void main(String[] args) throws Exception {
//		testCJ48();
//		compareCJ48ToJ48();
		testChiSquaredAttributeEval();
	}
	
	public static void testChiSquaredAttributeEval() throws Exception {
		
		// Loading data
		File file = new File("/Users/Sam/Google Drive/Research/Code/R package/Java Forest/p450.csv");
		Instances train = null;
		CSVLoader loader = new CSVLoader();
		loader.setFile(file);
		train = loader.getDataSet();
		
		// Configuring data
		NumericToNominal numToNom = new NumericToNominal();
		numToNom.setInputFormat(train);
		train = Filter.useFilter(train, numToNom);
		train.setClassIndex(0);
		
		// Testing Chi-Squared File
		ChiSquaredAttributeEval chi = new ChiSquaredAttributeEval();
		chi.buildEvaluator(train);
		Double pval = chi.evaluateAttribute(1);
		System.out.println("Chi^2: " + pval);
		
		System.out.println(train.attribute(7).isNumeric());
	}
	
	public static void testJ48() throws Exception {
		
		// Loading data
		File file = new File("/Users/Sam/Google Drive/Research/Code/R package/Java Forest/p450.csv");
		Instances train = null;
		CSVLoader loader = new CSVLoader();
		loader.setFile(file);
		train = loader.getDataSet();
		
		// Configuring data
		NumericToNominal numToNom = new NumericToNominal();
		numToNom.setInputFormat(train);
		train = Filter.useFilter(train, numToNom);
		train.setClassIndex(0);
		
		// Building Classifier
		J48 j48 = new J48();
		j48.buildClassifier(train);
		
		// Evaluating Classifier
		Evaluation eval = new Evaluation(train);
		eval.crossValidateModel(j48, train, 10, new Random(0));
		System.out.println(eval.toSummaryString("\nResults\n", true));
	}

	public static void testCJ48() throws Exception {
		
		// Loading data
		File file = new File("/Users/Sam/Google Drive/Research/Code/R package/Java Forest/p450.csv");
		Instances train = null;
		CSVLoader loader = new CSVLoader();
		loader.setFile(file);
		train = loader.getDataSet();
		
		// Configuring data
		NumericToNominal numToNom = new NumericToNominal();
		numToNom.setInputFormat(train);
		train = Filter.useFilter(train, numToNom);
		train.setClassIndex(0);
		
		// Building Classifier
		CJ48 cj48 = new CJ48();
		cj48.buildClassifier(train);
		
		// Evaluating Classifier
		Evaluation eval = new Evaluation(train);
		eval.crossValidateModel(cj48, train, 10, new Random(0));
		System.out.println(
				eval.toSummaryString("\nCJ48 10-fold CV Results\n", true));
	}
	
	public static void compareCJ48ToJ48() throws Exception {
		
		// Loading data
		String path = "/Users/Sam/Google Drive/Research/Code/R package/" + 
				"Java Forest/p450.csv";
		File file = new File(path);
		Instances train = null;
		CSVLoader loader = new CSVLoader();
		loader.setFile(file);
		train = loader.getDataSet();
		
		// Configuring data
		NumericToNominal numToNom = new NumericToNominal();
		numToNom.setInputFormat(train);
		train = Filter.useFilter(train, numToNom);
		train.setClassIndex(0);
		
		// Building Classifiers
		CJ48 cj48 = new CJ48();
		J48 j48 = new J48();
		cj48.buildClassifier(train);
		j48.buildClassifier(train);
		
		// Comparing Classifiers
		Evaluation eval = new Evaluation(train);
		eval.crossValidateModel(cj48, train, 10, new Random(0));
		System.out.println(eval.toSummaryString("CJ48 10-fold CV Results\n", true));
		eval = new Evaluation(train);
		eval.crossValidateModel(j48, train, 10, new Random(0));
		System.out.println(eval.toSummaryString("J48 10-fold CV Results\n", true));
		
		// Displaying Trees	
		visualizeTree(cj48, "CJ48");
		visualizeTree(j48, "J48");
	}
	
	public static void visualizeTree(Drawable d, String msg) throws Exception {
		
		 final javax.swing.JFrame jf = 
			       new javax.swing.JFrame(msg);
	     jf.setSize(500,400);
	     jf.getContentPane().setLayout(new BorderLayout());
	     TreeVisualizer tv = new TreeVisualizer(null, d.graph(), new PlaceNode2());
	     jf.getContentPane().add(tv, BorderLayout.CENTER);
	     jf.addWindowListener(new java.awt.event.WindowAdapter() {
	       public void windowClosing(java.awt.event.WindowEvent e) {
	         jf.dispose();
	       }
	     });
	     jf.setVisible(true);
	     tv.fitToScreen();
	}
}
