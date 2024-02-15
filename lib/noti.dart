import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'dart:math';

class Noti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future zonedScheduleNotification(
      {required FlutterLocalNotificationsPlugin fln}) async {
    await fln.cancelAll();
    int id = Random().nextInt(10000);
    int addHours = 2;
    if (DateTime.now().hour > 18) {
      addHours = 1;
    }
    if (DateTime.now().hour > 22) {
      addHours = 9 + (23 - DateTime.now().hour);
    }
    if (DateTime.now().hour < 9) {
      addHours = (9 - DateTime.now().hour);
    }
    DateTime date = DateTime.now().add(Duration(hours: addHours));
    print(date.toString());
    //print(tz.TZDateTime.parse(tz.local, date.toString()).toString());
    try {
      await fln.zonedSchedule(
        id,
        "thời gian để học tiếng Việt!",
        "bây giờ, nhanh đi!",
        tz.TZDateTime.parse(tz.local, date.toString()),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id', 'your channel name',
            channelDescription: 'your channel description',
            //largeIcon: DrawableResourceAndroidBitmap("logo"),
            //icon: "ic_launcher",
            //playSound: true,
            //sound: RawResourceAndroidNotificationSound('bell_sound')
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      return id;
    } catch (e) {
      print("Error at zonedScheduleNotification----------------------------$e");
      if (e ==
          "Invalid argument (scheduledDate): Must be a date in the future: Instance of 'TZDateTime'") {
        print("Select future date");
      }
      return -1;
    }
  }
}

/*
tz.TZDateTime _nextInstanceOfTenAM() {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local, now.year, now.month, now.day, now.hour + 1, now.minute + 1);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}
*/
