package snoozr.neural;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class DatabaseHelper extends SQLiteOpenHelper {
	public static final int DATABASE_VERSION = 1;
	public static final String DATABASE_NAME = "Snoozr.db";
	
	public static final String LAYER_NAME = "Layers";
	public static final String RECORD_NAME = "Records";
	public static final String KEY = "key";
	public static final String VALUE = "value";
	
	public DatabaseHelper(Context context) {
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
	}
	
	public void onCreate(SQLiteDatabase db) {
		db.execSQL("CREATE TABLE " + LAYER_NAME + " (" + KEY + " TEXT, " + VALUE + " TEXT)");
		db.execSQL("CREATE TABLE " + RECORD_NAME + " (" + KEY + " INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, " + VALUE + " TEXT)");
	}
	
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		db.execSQL("DROP TABLE IF EXISTS " + LAYER_NAME);
		db.execSQL("DROP TABLE IF EXISTS " + RECORD_NAME);
		onCreate(db);
	}
}