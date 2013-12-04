package snoozr.neural;

import android.content.ContentValues;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

import com.cedarsoftware.util.io.JsonReader;
import com.cedarsoftware.util.io.JsonWriter;

public class TrainingRecord {	
	public Points input;
	public Points output;
	
	TrainingRecord(Points input, Points output) {
		this.input = input;
		this.output = output;
	}
	
	public double[] getInputs() {
		return input.points;
	}
	
	public double[] getOutputs() {
		return output.points;
	}
	
	public static TrainingRecord fromJson(String json) {
		try {
			return (TrainingRecord) JsonReader.jsonToJava(json);
		} catch (Exception e) {
			return null;
		}
	}
	
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