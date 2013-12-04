package snoozr.neural;

import java.util.ArrayList;
import java.util.Arrays;

import com.cedarsoftware.util.io.JsonReader;
import com.cedarsoftware.util.io.JsonWriter;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

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
			DatabaseHelper dbHelper = new DatabaseHelper(context);
			SQLiteDatabase db = dbHelper.getReadableDatabase();
			
			Cursor cursor = db.query(DatabaseHelper.TABLE_NAME,
					new String[] {DatabaseHelper.VALUE},
					DatabaseHelper.KEY + " = ?",
					new String[] {key}, null, null, null);
			
			String json = null;
			if (cursor.moveToFirst()) {
				json = cursor.getString(cursor.getColumnIndex(DatabaseHelper.VALUE));
			}
			
			cursor.close();
			db.close();
			
			return (Layer) JsonReader.jsonToJava(json);
		} catch (Exception e) {
			return new Layer();
		}
	}
	
	public boolean writeToDB(Context context, String key) {
		try {
			String json = JsonWriter.objectToJson(this);
			
			ContentValues values = new ContentValues();
			values.put(DatabaseHelper.KEY, key);
			values.put(DatabaseHelper.VALUE, json);
			
			DatabaseHelper dbHelper = new DatabaseHelper(context);
			SQLiteDatabase db = dbHelper.getWritableDatabase();
			
			db.insertOrThrow(DatabaseHelper.TABLE_NAME, null, values);
			
			db.close();
			
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	public int size() {
		return deltas.size();
	}
	
	public Double[] getDeltas() {
		return deltas.toArray(new Double[deltas.size()]);
	}
	
	public Double[] getErrors() {
		return errors.toArray(new Double[errors.size()]);
	}
	
	public Double[] getOutputs() {
		return outputs.toArray(new Double[outputs.size()]);
	}
	
	public Double[] getWeights() {
		return weights.toArray(new Double[weights.size()]);
	}
	
	public Double[] getChanges() {
		return changes.toArray(new Double[changes.size()]);
	}
	
	public double getBias(int ndx) {
		return biases.get(ndx);
	}
	
	public void setDelta(int index, double delta) {
		deltas.set(index, delta);
	}
	
	public void setError(int index, double error) {
		errors.set(index, error);
	}
	
	public void setChange(int index, double change) {
		changes.set(index, change);
	}
	
	public void setOutput(int index, double output) {
		outputs.set(index, output);
	}
	
	public void incrememntWeight(int index, double delta) {
		weights.set(index, weights.get(index) + delta);
	}
	
	public void incrememntBias(int index, double delta) {
		biases.set(index, biases.get(index) + delta);
	}
	
	public void replaceOutputs(Double[] vals) {
		for (int i = 0; i < vals.length; i++)
			outputs.set(i, vals[i]);
	}
}