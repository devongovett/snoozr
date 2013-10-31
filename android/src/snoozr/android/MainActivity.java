package snoozr.android;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import android.os.Bundle;
import android.app.Activity;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Point;
import android.view.Display;
import android.view.GestureDetector.OnGestureListener;
import android.view.GestureDetector;
import android.view.Menu;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.DigitalClock;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

public class MainActivity extends Activity implements OnGestureListener{

	Context context = MainActivity.this;
	private GestureDetector gestureScanner;
	TextView hrMin, amPm, month, day;
	SimpleDateFormat timeParse = new SimpleDateFormat("hh:mm");
	Date alarmTime = new Date();
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        final ImageButton sleep = (ImageButton) findViewById(R.id.sleep_button);
        final ImageButton settings = (ImageButton) findViewById(R.id.settings_button);
        
        hrMin = (TextView) findViewById(R.id.hrMin);
        amPm = (TextView) findViewById(R.id.amPm);
        month = (TextView) findViewById(R.id.month);
        day = (TextView) findViewById(R.id.day);
        
        gestureScanner = new GestureDetector(this);
        updateTime(0);
        
        sleep.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View arg0) {
				
				setupAlarm();

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
    
    public void setupAlarm(){    	
		Intent intentAlarm = new Intent(context, AlarmReciever.class);
		Calendar cal = Calendar.getInstance();
		cal.setTime(alarmTime);
		int currHour = cal.get(Calendar.HOUR_OF_DAY);
		int currMin = cal.get(Calendar.MINUTE);
		
		long time = cal.getTimeInMillis();
		
		AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
		
		alarmManager.set(AlarmManager.RTC_WAKEUP, time, PendingIntent.getBroadcast(context, 1,  intentAlarm, PendingIntent.FLAG_UPDATE_CURRENT));
		
		Toast.makeText(context, new Date(time).toString(), Toast.LENGTH_LONG).show();
		
    }
    
    private String monthText(int i){
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

	private void updateTime(int addMin){
    	Calendar cal = Calendar.getInstance();
    	cal.setTime(alarmTime);
    	cal.add(Calendar.MINUTE, addMin);
    	alarmTime = cal.getTime();

    	hrMin.setText(timeParse.format(alarmTime));
    	amPm.setText(cal.get(Calendar.AM_PM) == Calendar.AM 
    			? getResources().getString(R.string.am) : getResources().getString(R.string.pm));
    	day.setText("" + cal.get(Calendar.DATE));
    	month.setText(monthText(cal.get(Calendar.MONTH) + 1));
    }
    
    @Override
    public boolean onTouchEvent(MotionEvent me) {
		return gestureScanner.onTouchEvent(me);
    }


    public boolean onDown(MotionEvent e) {
    	//clock.setText("-" + "DOWN" + "-");
        return true;
    }

    public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
    	//clock.setText("-" + "FLING" + "-");
        return true;
    }


    public void onLongPress(MotionEvent e) {
    	//clock.setText("-" + "LONG PRESS" + "-");
    }


    public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
    	//clock.setText("-" + "SCROLL" + "-");
    	Display display = getWindowManager().getDefaultDisplay();
    	int width = display.getWidth(), factor = (int)((width - e2.getX()) / width * distanceY); 
		if(factor == 0 && (distanceY > 0 || distanceY < 0))
			factor = distanceY > 0 ? 1 : -1;
		
    	updateTime(factor);
        return true;
    }


    public void onShowPress(MotionEvent e) {
    	//clock.setText("-" + "SHOW PRESS" + "-");
    }


    public boolean onSingleTapUp(MotionEvent e) {
    	//clock.setText("-" + "SINGLE TAP UP" + "-");
        return true;
    }
    
}
