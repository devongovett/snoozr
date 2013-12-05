package snoozr.android;

import java.io.IOException;
import java.text.DateFormat;
import java.util.Calendar;

import android.app.Activity;
import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;
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
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);

		final MediaPlayer mPlayer = new MediaPlayer();

		final TextView time = (TextView) findViewById(R.id.curAlarmTime);
		final Button dismiss = (Button) findViewById(R.id.dismissButton);
		final Button snooze = (Button) findViewById(R.id.snoozeButton);

		time.setText(DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.SHORT).format(cal.getTime()));
		
		String sound = getSharedPreferences("snoozr.android", Context.MODE_PRIVATE).getString("sound", "");
		int type = R.raw.church_bells;
		
		if (getString(R.string.alarm).equals(sound))
			type = R.raw.alarm;
		else if (getString(R.string.beep).equals(sound))
			type = R.raw.beep;
		else if (getString(R.string.police).equals(sound))
			type = R.raw.police;
		
		try {
			mPlayer.setAudioStreamType(AudioManager.STREAM_ALARM);
			mPlayer.setDataSource(this, Uri.parse("android.resource://snoozr.android/" + type));
			mPlayer.setLooping(true);
			mPlayer.prepare();
			mPlayer.start();
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		int maxSnoozes = getSharedPreferences("snoozr.android", Context.MODE_PRIVATE).getInt("allowedSnoozes", 5);
		final int numSnoozes = getIntent().getIntExtra("snoozes", maxSnoozes);

		if (numSnoozes >= maxSnoozes)
			snooze.setVisibility(View.GONE);

		dismiss.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View arg0) {
				mPlayer.stop();
				finish();
			}
		});

		snooze.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				mPlayer.stop();
				cal.add(Calendar.MINUTE, 5);
				Utilities.setupAlarm(cal.getTime(), AlarmActivity.this, numSnoozes + 1);

				Toast toast = Toast.makeText(AlarmActivity.this,
						"Snoozing for 5 more minutes", Toast.LENGTH_LONG);
				toast.show();
				finish();
			}
		});

		if (numSnoozes == 0)
			AlarmPredictor.getInstance(this).addRecord(cal.getTime());
	}
}
