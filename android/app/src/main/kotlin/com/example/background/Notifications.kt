package com.example.background

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import android.graphics.BitmapFactory ;

object Notifications {
    const val NOTIFICATION_ID_BACKGROUND_SERVICE = 111

    private const val CHANNEL_ID_BACKGROUND_SERVICE = "fall_detection_background"

    fun createNotificationChannels(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID_BACKGROUND_SERVICE,
                "Background Service",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }

    // Create an explicit intent for an Activity in your app
    // val intent = Intent(this, AlertDetails::class.java).apply {
    //     flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
    // }
    // val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, intent, 0)

    //define notification parameters
    fun buildForegroundNotification(context: Context): Notification {
        return NotificationCompat
            .Builder(context, CHANNEL_ID_BACKGROUND_SERVICE)
            .setSmallIcon(R.drawable.notification_icon)
            .setLargeIcon(BitmapFactory.decodeResource(context.getResources(),
                        R.drawable.notification_icon))
            .setContentTitle("Happy Gramps")
            .setContentText("Fall Detection is Active")
            //.setContentIntent(pendingIntent)
            .build()
    }
}