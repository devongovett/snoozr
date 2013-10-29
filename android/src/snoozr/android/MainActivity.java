package snoozr.android;

import java.util.Calendar;
import java.util.Date;

import android.os.Bundle;
import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.DigitalClock;
import android.widget.ImageButton;
import android.widget.TimePicker;
import android.widget.Toast;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        final TimePicker clock = (TimePicker) findViewById(R.id.clock);
        final ImageButton sleep = (ImageButton) findViewById(R.id.sleep_button);
        final ImageButton settings = (ImageButton) findViewById(R.id.settings_button);
        
        sleep.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View arg0) {
				Context context = MainActivity.this;
				
				Intent intentAlarm = new Intent(context, AlarmReciever.class);
				
				int hour = clock.getCurrentHour();
				int minute = clock.getCurrentMinute();
				
				Calendar cal = Calendar.getInstance();
				int currHour = cal.get(Calendar.HOUR_OF_DAY);
				int currMin = cal.get(Calendar.MINUTE);
				
				long extra = 0;
				if (hour < currHour || (hour == currHour && minute < currMin))
					extra = 24 * 60 *60 * 1000;
				
				cal.set(Calendar.HOUR_OF_DAY, hour);
				cal.set(Calendar.MINUTE, minute);
				cal.set(Calendar.SECOND, 0);
				
				long time = cal.getTimeInMillis() + extra;
				
				AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
				
				alarmManager.set(AlarmManager.RTC_WAKEUP, time, PendingIntent.getBroadcast(context, 1,  intentAlarm, PendingIntent.FLAG_UPDATE_CURRENT));
				
				Toast.makeText(context, new Date(time).toString(), Toast.LENGTH_LONG).show();
				
                Toast toast = Toast.makeText(context,
                        "Sleep tight!", Toast.LENGTH_LONG);
                toast.show();
                finish();
			}  	
        }); 
        
        settings.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View arg0) {
				startActivity(new Intent(MainActivity.this, SettingsActivity.class));
			}  	
        }); 
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
    
}
