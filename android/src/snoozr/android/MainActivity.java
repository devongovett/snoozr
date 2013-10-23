package snoozr.android;

import android.os.Bundle;
import android.app.Activity;
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
        
        TimePicker clock = (TimePicker) findViewById(R.id.clock);
        ImageButton sleep = (ImageButton) findViewById(R.id.sleep_button);
        ImageButton settings = (ImageButton) findViewById(R.id.settings_button);
        
        sleep.setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View arg0) {
                Toast toast = Toast.makeText(MainActivity.this,
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
