package snoozr.neural;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

import com.cedarsoftware.util.io.JsonReader;
import com.cedarsoftware.util.io.JsonWriter;

/****
 * Holds the data to train the neural net
 * 
 * @author Donovan McKelvey
 *
 */
public class TrainingRecord {	
	public Points input;
	public Points output;
	
	/****
	 * Creates a record
	 * 
	 * @param input The input for the record
	 * @param output The correct output for the record
	 */
	public TrainingRecord(Points input, Points output) {
		this.input = input;
		this.output = output;
	}
	
	/****
	 * Gets the inputs
	 * 
	 * @return An array holding the input values
	 */
	public double[] getInputs() {
		return input.points;
	}
	
	/****
	 * Gets the outputs
	 * 
	 * @return An array holding the output values
	 */
	public double[] getOutputs() {
		return output.points;
	}
	
	/****
	 * Creates a training record from the given json
	 * 
	 * @param json The json representing this record
	 * @return The record represented by the json
	 */
	public static TrainingRecord fromJson(String json) {
		try {
			return (TrainingRecord) JsonReader.jsonToJava(json);
		} catch (Exception e) {
			return null;
		}
	}
	
	/****
	 * Saves the current record to the database in json format
	 * 
	 * @param context
	 * @return whether or not the database write was successful
	 */
	public boolean writeToDB(Context context) {
		try {
			String json = JsonWriter.objectToJson(this);
			
			ContentValues values = new ContentValues();
			values.put(DatabaseHelper.VALUE, json);
			
			DatabaseHelper dbHelper = new DatabaseHelper(context);
			SQLiteDatabase db = dbHelper.getWritableDatabase();
			
			db.insertOrThrow(DatabaseHelper.RECORD_NAME, null, values);
			
			db.close();
			
			return true;
		} catch (Exception e) {
			return false;
		}
	}
}