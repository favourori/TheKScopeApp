
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PushNotifs {
 final BuildContext context;
 PushNotifs({this.context});
 static Future setPref(_, List<String> notifItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   // print(prefs);
    
      if (prefs.getString('_notif') != null) {
        prefs.remove('_notif');

        prefs.setStringList('_notif', notifItem);
        print("SAVED NOTIF " + prefs.getString('_notif') ?? "ERROR");

        notifItem = prefs.getStringList('_notif');
      }
  }

static Future showNotificationWithDefaultSound(String title, String body, flutterLocalNotificationsPlugin) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: body,
    );
  }
 static Future onSelectNotification(String payload, context, _showDialog) async {
    showDialog(
      context: context,
      builder: (_) {
        _showDialog();
        return new AlertDialog(
          title: Text("$payload"),
        );
      },
    );
  }
}