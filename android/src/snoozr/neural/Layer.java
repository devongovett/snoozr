package snoozr.neural;

import com.cedarsoftware.util.io.JsonReader;
import com.cedarsoftware.util.io.JsonWriter;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

public class Layer {	
	public double[] deltas;
	public double[] errors;
	public double[] outputs;
	public double[] biases;
	public double[] weights;
	public double[] changes;
	
	public Layer(double[] deltas, double[] errors, double[] outputs) {
		this.deltas = deltas;
		this.errors = errors;
		this.outputs = outputs;
	}
	
	public Layer(double[] deltas, double[] errors, double[] outputs, double[] biases, double[] weights, double[] changes) {
		this(deltas, errors, outputs);

		this.biases = biases;
		this.weights = weights;
		this.changes = changes;
	}
	
	public static Layer fromDB(Context context, String key) {
		try {
			DatabaseHelper dbHelper = new DatabaseHelper(context);
			SQLiteDatabase db = dbHelper.getReadableDatabase();
			
			Cursor cursor = db.query(DatabaseHelper.LAYER_NAME,
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
			return null;
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
			
			db.insertOrThrow(DatabaseHelper.LAYER_NAME, null, values);
			
			db.close();
			
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	public int size() {
		return deltas.length;
	}
}