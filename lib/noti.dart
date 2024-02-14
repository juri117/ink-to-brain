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

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      //playSound: true,
      //sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, not);
  }

  static Future showScheduledNotification(
      {required FlutterLocalNotificationsPlugin fln}) async {
    //tz.TZDateTime time = _nextInstanceOfTenAM();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
    var currentDateTime =
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));
    print(currentDateTime);
    await fln.zonedSchedule(
        0,
        'daily scheduled notification title',
        'daily scheduled notification body',
        currentDateTime,
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future zonedScheduleNotification(
      {required FlutterLocalNotificationsPlugin fln}) async {
    // IMPORTANT!!
    //tz.initializeTimeZones(); --> call this before using tz.local (ideally put it in your init state)

    int id = Random().nextInt(10000);
    int addHours = 3;
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
    //print(date.toString());
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
