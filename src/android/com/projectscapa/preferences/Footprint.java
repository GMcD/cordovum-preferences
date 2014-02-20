package com.projectscapa.tag;

import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.util.UUID;

import android.content.Context;
import android.telephony.TelephonyManager;

public class Footprint {

	public static final String PACKAGE_NAME = "com.projectscapa.preferences";
	public static final String PORTAL_HOST = "www.projectscapa.com";

	public static final String deviceId(Context context){
 	   	final TelephonyManager telephonyManager = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
 	   	final String tmDevice, tmSerial, androidId;
 	    tmDevice = "" + telephonyManager.getDeviceId();
 	    tmSerial = "" + telephonyManager.getSimSerialNumber();
 	    androidId = "" + android.provider.Settings.Secure.getString(context.getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);

 	    UUID deviceUuid = new UUID(androidId.hashCode(), ((long)tmDevice.hashCode() << 32) | tmSerial.hashCode());
 	    String deviceId = deviceUuid.toString();
 	    return deviceId;
	}
	
	public static final Boolean isReachable(){
		boolean exists = false;

		try {
		    SocketAddress sockaddr = new InetSocketAddress(PORTAL_HOST, 80);
		    // Create an unbound socket
		    Socket sock = new Socket();

		    // This method will block no more than timeoutMs.
		    // If the timeout occurs, SocketTimeoutException is thrown.
		    int timeoutMs = 2000;   // 2 seconds
		    sock.connect(sockaddr, timeoutMs);
		    exists = true;
		} catch (Exception e){
		}
		return exists;
	}
}
