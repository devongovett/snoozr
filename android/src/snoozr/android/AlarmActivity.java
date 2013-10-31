package snoozr.android;

import java.text.DateFormat;
import java.util.Calendar;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

public class AlarmActivity extends Activity{
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_alarm);
		
        final Calendar cal = Calendar.getInstance();
        
        final TextView time = (TextView) findViewById(R.id.curAlarmTime);
        final Button dismiss = (Button) findViewById(R.id.dismissButton);
        final Button snooze = (Button) findViewById(R.id.snoozeButton);
		
        time.setText(DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.SHORT).format(cal.getTime()));
        
        dismiss.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View arg0) {
				finish();
			}
        });

        snooze.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				cal.add(Calendar.MINUTE, 5);
				Utilities.setupAlarm(cal.getTime(), AlarmActivity.this);
				
                Toast toast = Toast.makeText(AlarmActivity.this,
                        "Snoozing for 5 more minutes", Toast.LENGTH_LONG);
                toast.show();
				finish();
			}
        });
	}
}
