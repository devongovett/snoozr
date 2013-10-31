package snoozr.android;


import android.os.Bundle;
import android.app.Activity;
import android.app.ListActivity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.Log;
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
			boolean isCategory;
			int resId = (isCategory = (position == 0 || position == 4 || position == 7 || position == 9)) 
					? R.layout.settings_row_category : R.layout.settings_row_selectable;
			View item = inflater.inflate(resId, parent, false);

			TextView rightText = (TextView)(isCategory ? 
					 item.findViewById(R.id.settingsRowCategoryDescription) : item.findViewById(R.id.settingsRowSelectableDescription));
			
			rightText.setText(entries[position]);	
			return item;
		}	
	}
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);
        
        ListView lv = getListView();
        
    	SettingsAdapter adapter = new SettingsAdapter(SettingsActivity.this, R.layout.settings_row_image, 
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
