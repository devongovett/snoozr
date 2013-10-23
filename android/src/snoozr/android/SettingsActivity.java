package snoozr.android;


import android.os.Bundle;
import android.app.Activity;
import android.app.ListActivity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

public class SettingsActivity extends ListActivity {

	public class SettingsAdapter extends ArrayAdapter<String>{
        
		String[] entries;
		Context context;
		int layoutResourceId;

		public SettingsAdapter(Context context, int layoutResourceId, String[] entries) {            
			super(context, layoutResourceId, entries);
			this.entries=entries;
            this.context = context;
            this.layoutResourceId = layoutResourceId;
		}
    
		@Override
		public View getView(int position, View convertView, ViewGroup parent) {
			LayoutInflater inflater = ((Activity)context).getLayoutInflater();
			View item = inflater.inflate(layoutResourceId, parent, false);

			TextView rowText = (TextView)item.findViewById(R.id.settingsRowText); // title
			ImageView rowImage = (ImageView)item.findViewById(R.id.settingsRowImage); // thumb image

			rowText.setText(entries[position]);
        
			Drawable d;
        
			switch(position){
                case 0:
                        d = item.getResources().getDrawable(R.drawable.alarm_icon);
                        break;
                case 1:
                        d = item.getResources().getDrawable(R.drawable.cycle_icon);
                        break;
                default:
                        d = item.getResources().getDrawable(R.drawable.ic_launcher);
                        break;
			}
        
			rowImage.setImageDrawable(d);              
			return item;
		}
		
	}
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);
        
        ListView lv = getListView();
        
    	SettingsAdapter adapter = new SettingsAdapter(SettingsActivity.this, R.layout.settings_row, 
    			getResources().getStringArray(R.array.settings));
    	lv.setAdapter(adapter);
    	
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
    
}
