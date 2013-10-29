package snoozr.android;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.telephony.SmsManager;
import android.widget.Toast;

public class AlarmReciever extends BroadcastReceiver {

	@Override
	public void onReceive(Context context, Intent intent) {
		String phoneNumberReciver="6617132314";// phone number to which SMS to be send
        String message="This is your snoozr alarm";// message to send
        SmsManager sms = SmsManager.getDefault(); 
        sms.sendTextMessage(phoneNumberReciver, null, message, null, null);
        // Show the toast  like in above screen shot
        Toast.makeText(context, "Alarm Triggered and SMS Sent", Toast.LENGTH_LONG).show();
	}
	
}