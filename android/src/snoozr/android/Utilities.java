package snoozr.android;

import java.util.Calendar;
import java.util.Date;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

public class Utilities {

    public static void setupAlarm(Date alarmTime, Context context){    	
		Intent intentAlarm = new Intent(context, AlarmReciever.class);
		Calendar cal = Calendar.getInstance();
		cal.setTime(alarmTime);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		long time = cal.getTimeInMillis();
		
		AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
		
		alarmManager.set(AlarmManager.RTC_WAKEUP, time, PendingIntent.getBroadcast(context, 1,  intentAlarm, PendingIntent.FLAG_UPDATE_CURRENT));
		
		Toast.makeText(context, new Date(time).toString(), Toast.LENGTH_LONG).show();
    }
    
    public static String monthText(int i){
    	switch(i){
    		case 1: return "January";
    		case 2: return "Febuary";
    		case 3: return "March";
    		case 4: return "April";
    		case 5: return "May";
    		case 6: return "June";
    		case 7: return "July";
    		case 8: return "August";
    		case 9: return "September";
    		case 10: return "October";
    		case 11: return "November";
    		case 12: return "December";
    		default: return "wtf";
    	}
    }
}
