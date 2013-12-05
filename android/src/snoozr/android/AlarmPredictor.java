package snoozr.android;

import java.util.Calendar;
import java.util.Date;

import snoozr.neural.DatabaseHelper;
import snoozr.neural.NeuralNet;
import snoozr.neural.Points;
import snoozr.neural.TrainingRecord;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

public class AlarmPredictor {	
	private static final double[] DAY_IN = {0.000, 0.167, 0.333, 0.50, 0.667, 0.833, 1.000};
	private static final int ROUND_TIME = 5;
	
	private static AlarmPredictor predictor = null;
	
	private TrainingRecord[] records;
	private NeuralNet net;
	private Context context;
	
	private int count[];
	private double sum[];
	
	public static AlarmPredictor getInstance(Context context) {
		if (predictor == null)
			predictor = new AlarmPredictor(context);
		
		return predictor;
	}
	
	private AlarmPredictor(Context context) {
		this.context = context;
		
		DatabaseHelper dbHelper = new DatabaseHelper(context);
		SQLiteDatabase db = dbHelper.getReadableDatabase();
		
		Cursor cursor = db.query(DatabaseHelper.RECORD_NAME,
				new String[] {DatabaseHelper.VALUE},
				null, null, null, null, null);
		
		int ndx = cursor.getColumnIndex(DatabaseHelper.VALUE);
		records = new TrainingRecord[cursor.getCount()];
		
		try {
			int pos = 0;
			while (cursor.moveToNext()) {
				TrainingRecord record = TrainingRecord.fromJson(cursor.getString(ndx));
				
				if (record == null)
					throw new Exception();
				
				records[pos++] = record;
			}
		} catch (Exception e) {
			records = new TrainingRecord[0];
		}
		
		cursor.close();
		db.close();
		
		count = new int[7];
		sum = new double[7];
		for (TrainingRecord record : records) {
			int day = getDateFromFraction(record.getInputs()[0]);
			count[day]++;
			sum[day] += record.getOutputs()[0];
		}
		
		net = NeuralNet.fromDB(context);
		if (net == null) {
			getTrainedNet();
		}
	}
	
	private int getDateFromFraction(double val) {
		for (int i = 0; i < 7; i++)
			if (DAY_IN[i] == val)
				return i;
		return 0;
	}
	
	private void getTrainedNet() {
		net = new NeuralNet(1, 1);
		net.minError = 0.0001;
		net.learningRate = 0.8;
		net.maxIterations = 75000;
		net.train(records);
	}
	
	private void save() {
		DatabaseHelper dbHelper = new DatabaseHelper(context);
		SQLiteDatabase db = dbHelper.getWritableDatabase();
		db.delete(DatabaseHelper.RECORD_NAME, null, null);
		db.close();
		
		for (TrainingRecord record : records)
			record.writeToDB(context);
		net.writeToDB(context);
	}
	
	public void reset() {
		records = new TrainingRecord[0];
		count = new int[7];
		sum = new double[7];
		getTrainedNet();
		save();
	}
	
	public void addRecord(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		
		double in = DAY_IN[cal.get(Calendar.DAY_OF_WEEK) - 1];
		double out = ((double) (cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE))) / (24.0 * 60.0);
		TrainingRecord record = new TrainingRecord(new Points(in), new Points(out));
		
		TrainingRecord[] tmp = new TrainingRecord[records.length + 1];
		System.arraycopy(records, 0, tmp, 0, records.length);
		tmp[records.length] = record;
		records = tmp;
		
		getTrainedNet();
		save();
	}
	
	public Date getPrediction() {
		Calendar cal = Calendar.getInstance();
		
		boolean sameDay = cal.get(Calendar.HOUR_OF_DAY) < 5;
		
		int day = (cal.get(Calendar.DAY_OF_WEEK) - (sameDay ? 1 : 0)) % 7;
		int min = 8 * 60;
		
		if (count[day] > 0) {
			double netOutput = net.runInput(day)[0] * 60 * 24;
			double avg = count[day] / count[day];
			
			double netAvg = (netOutput + avg) / 2;
			min = (int) netAvg;
			
			if (avg > netAvg)
				min += ROUND_TIME;
			
			if (avg != netAvg)
				min -= (min % ROUND_TIME);
		}		
		
		if (!sameDay)
			cal.add(Calendar.DATE, 1);
		cal.set(Calendar.HOUR_OF_DAY, min / 60);
		cal.set(Calendar.MINUTE, min % 60);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		
		return cal.getTime();
	}
}