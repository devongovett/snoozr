package snoozr.neural;

import java.util.ArrayList;
import java.util.Arrays;

import com.cedarsoftware.util.io.JsonReader;
import com.cedarsoftware.util.io.JsonWriter;

import android.content.Context;

public class Layer {	
	private ArrayList<Double> deltas;
	private ArrayList<Double> errors;
	private ArrayList<Double> outputs;
	private ArrayList<Double> biases;
	private ArrayList<Double> weights;
	private ArrayList<Double> changes;
	
	public Layer() {		
		deltas = new ArrayList<Double>();
		errors = new ArrayList<Double>();
		outputs = new ArrayList<Double>();
		biases = new ArrayList<Double>();
		weights = new ArrayList<Double>();
		changes = new ArrayList<Double>();
	}
	
	public Layer(Double[] deltas, Double[] errors, Double[] outputs) {
		this();
		
		this.deltas.addAll(Arrays.asList(deltas));
		this.errors.addAll(Arrays.asList(errors));
		this.outputs.addAll(Arrays.asList(outputs));
	}
	
	public Layer(Double[] deltas, Double[] errors, Double[] outputs, Double[] biases, Double[] weights, Double[] changes) {
		this(deltas, errors, outputs);

		this.biases.addAll(Arrays.asList(biases));
		this.weights.addAll(Arrays.asList(weights));
		this.changes.addAll(Arrays.asList(changes));
	}
	
	public static Layer fromDB(Context context, String key) {
		try {
			String json = "";
			return (Layer) JsonReader.jsonToJava(json);
		} catch (Exception e) {
			return new Layer();
		}
	}
	
	public boolean writeToDB(String key) {
		try {
			String json = JsonWriter.objectToJson(this);
			
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	public int size() {
		return deltas.size();
	}
}