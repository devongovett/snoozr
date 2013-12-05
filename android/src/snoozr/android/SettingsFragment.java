package snoozr.android;


import android.os.Bundle;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceClickListener;
import android.preference.PreferenceFragment;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.app.Dialog;
import android.content.Context;
import android.content.SharedPreferences;

public class SettingsFragment extends PreferenceFragment {
	
    @Override
	public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.layout.settings);
        
        final Context context = this.getActivity();
        
        Preference resetPreference = (Preference) getPreferenceScreen().findPreference("resetSchedule");
        resetPreference.setOnPreferenceClickListener(new OnPreferenceClickListener() {
            public boolean onPreferenceClick(Preference preference) {
            	
                        
                final Dialog dialog = new Dialog(getActivity());
                dialog.setContentView(R.layout.simple_dialog);
                dialog.setTitle("Confirmation");

                final TextView text = (TextView) dialog.findViewById(R.id.simple_dialot_text);
                final Button cancel = (Button) dialog.findViewById(R.id.simple_dialog_cancel);
                final Button confirm = (Button) dialog.findViewById(R.id.simple_dialog_confirm);
                   
                text.setText(getActivity().getResources().getString(R.string.confirmDelete));
                    
                cancel.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        dialog.dismiss();
                    }
                });

                confirm.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                    	AlarmPredictor.getInstance(context).reset();
                    	
                        dialog.dismiss();
                    }
                });

                dialog.show();
                return true;
            }
        });
        
        Preference aboutPreference = (Preference) getPreferenceScreen().findPreference("about");
        aboutPreference.setOnPreferenceClickListener(new OnPreferenceClickListener() {
            public boolean onPreferenceClick(Preference preference) {
            	
                        
                final Dialog dialog = new Dialog(getActivity());
                dialog.setContentView(R.layout.simple_dialog);
                dialog.setTitle(getActivity().getResources().getString(R.string.about));

                final TextView text = (TextView) dialog.findViewById(R.id.simple_dialot_text);
                ((Button) dialog.findViewById(R.id.simple_dialog_cancel)).setVisibility(View.GONE);
                final Button confirm = (Button) dialog.findViewById(R.id.simple_dialog_confirm);
                   
                text.setText(getActivity().getResources().getString(R.string.authors));
                confirm.setText(getActivity().getResources().getString(R.string.Ok));
                
                confirm.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                    	
                        dialog.dismiss();
                    }
                });
                
                dialog.show();
                return true;
            }
        });
    }

    public SharedPreferences getPreferences(){
    	return this.getActivity().getSharedPreferences("snoozr.android", Context.MODE_PRIVATE);
    }  
}
