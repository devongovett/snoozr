package snoozr.android;

import java.util.Calendar;
import java.util.Date;

import android.app.AlarmManager;
import android.app.Dialog;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.NumberPicker;
import android.widget.Toast;

public class Utilities {

	public static enum NumtoChange {NUMSNOOZES, SLEEPCYCLE};
	
    public static void setupAlarm(Date alarmTime, Context context){    	
		Intent intentAlarm = new Intent(context, AlarmReciever.class);
		Calendar cal = Calendar.getInstance();
		cal.setTime(alarmTime);
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
    
    /*public static void setupNumPickDialog(Context context, NumtoChange toChange){
    	final Dialog dialog = new Dialog(context);
        dialog.setContentView(R.layout.dialog_numpicker);
        
        NumberPicker number = (NumberPicker) dialog.findViewById(R.id.dialogNumber);
        Button cancel = (Button) dialog.findViewById(R.id.dialogCancel);
        Button ok = (Button) dialog.findViewById(R.id.dialogOk);
        
        Settings s = new Settings(context);
        
        if(toChange == NumtoChange.NUMSNOOZES)
        	number.setValue(s.numSnoozesAllowed);
        if(toChange == NumtoChange.SLEEPCYCLE)
        	number.setValue(s.sleepCycleMins);
        
        cancel.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View arg0) {
				dialog.dismiss();
			}  	
        }); 
        
        ok.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View arg0) {
				
				
				dialog.dismiss();
			}  	
        }); 
        
        dialog.show();
    }*/
}
