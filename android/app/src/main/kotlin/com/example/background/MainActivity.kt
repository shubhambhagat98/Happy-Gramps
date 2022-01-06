package com.example.background

import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

import android.Manifest
import android.os.Build
import android.content.pm.PackageManager
import android.telephony.SmsManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall

class MainActivity : FlutterActivity() {
   
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        
    //check for permission
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED && checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED && checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED && checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) { // Should we show an explanation?
                if (shouldShowRequestPermissionRationale(Manifest.permission.SEND_SMS)
                        && shouldShowRequestPermissionRationale(Manifest.permission.CAMERA)
                        && shouldShowRequestPermissionRationale(Manifest.permission.READ_EXTERNAL_STORAGE)
                        && shouldShowRequestPermissionRationale(Manifest.permission.ACCESS_FINE_LOCATION)) { // Show an explanation to the user *asynchronously* -- don't block
// this thread waiting for the user's response! After the user
// sees the explanation, try again to request the permission.
                } else { // No explanation needed, we can request the permission.
                    requestPermissions(arrayOf(Manifest.permission.SEND_SMS, Manifest.permission.CAMERA, Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.ACCESS_FINE_LOCATION),
                            0)
                    // MY_PERMISSIONS_REQUEST_SEND_SMS is an
// app-defined int constant. The callback method gets the
// result of the request.
                }
            }
        }

        //send sms method channel
        MethodChannel(flutterView,"sendSms").apply {
            setMethodCallHandler { method, result ->
                if (method.method == "send") {
                    val num = method.argument<String>("phone")
                    val msg = method.argument<String>("msg")
                    sendSMS(num, msg, result)
                } else {
                    result.notImplemented()
                }
            }
        }

        //fall detection active- continous notification
        Notifications.createNotificationChannels(this)

        //method channel to start background service when app is terminated ie: removed from application tray
        MethodChannel(flutterView, "com.example/background_service").apply {
            setMethodCallHandler { method, result ->
                if (method.method == "startService") {
                    val callbackRawHandle = method.arguments as Long
                    BackgroundService.startService(this@MainActivity, callbackRawHandle)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
        }


        //method channel to put app in background when user presses back button on homescreen and puts app in application tray
        MethodChannel(flutterView, "com.example/app_retain").apply {
            setMethodCallHandler { method, result ->
                if (method.method == "sendToBackground") {
                    moveTaskToBack(true)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
        }

        
    }

     private fun sendSMS(phoneNo: String?, msg: String?, result: MethodChannel.Result) {
        try {
            val smsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNo, null, msg, null, null)
            result.success("SMS Sent")
        } catch (ex: Exception) {
            ex.printStackTrace()
            result.error("Err", "Sms Not Sent", "")
        }
    } //send sms

      override fun onRequestPermissionsResult(requestCode: Int,
                                            permissions: Array<String>, grantResults: IntArray) {
        when (requestCode) {
            0 -> {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.isNotEmpty()
                        && ((grantResults[0]
                                + grantResults[1]
                                + grantResults[2]
                                + grantResults[3])
                                == PackageManager.PERMISSION_GRANTED)) { // permission was granted, yay! Do the
                        // contacts-related task you need to do.
                        //String num = call.argument("phone");
                        //String msg = call.argument("msg");
                        //sendSMS(num,msg,result);
                } else { // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                }
                return
            }
        }
    }
}
