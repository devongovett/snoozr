package snoozr.neural;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

/****
 * Helper method to handle device databases
 * 
 * @author Donovan McKelvey 
 */
public class DatabaseHelper extends SQLiteOpenHelper {
	public static final int DATABASE_VERSION = 1;
	public static final String DATABASE_NAME = "Snoozr.db";
	
	public static final String NET_NAME = "Net";
	public static final String RECORD_NAME = "Records";
	public static final String KEY = "key";
	public static final String VALUE = "value";
	
	/****
	 * Instantiates the database (called by android system)
	 * @param context
	 */
	public DatabaseHelper(Context context) {
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
	}
	
	/****
	 * Creates the tables needed (called by android system)
	 * @param db The device database
	 */
	public void onCreate(SQLiteDatabase db) {
		db.execSQL("CREATE TABLE " + NET_NAME + " (" + VALUE + " TEXT)");
		db.execSQL("CREATE TABLE " + RECORD_NAME + " (" + KEY + " INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, " + VALUE + " TEXT)");
	}
	
	/****
	 * Upgrades the tables when the database version changes (called by android system)
	 * @param db The device database
	 */
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		db.execSQL("DROP TABLE IF EXISTS " + NET_NAME);
		db.execSQL("DROP TABLE IF EXISTS " + RECORD_NAME);
		onCreate(db);
	}
}