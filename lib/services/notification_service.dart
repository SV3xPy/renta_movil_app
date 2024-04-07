import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); //

  Future<void> initNotifications() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableLights: true,
      enableVibration: true,
    );
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> scheduledNotification({
    required String title,
    required String body,
    required String date,
    required int notifID,
  }) async {
    DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);
    DateTime notificationDate = parsedDate.subtract(
      const Duration(days: 2),
    );
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    if (notificationDate.isBefore(now)) {
      Get.snackbar("Ya es muy tarde",
          "La fecha proporcionada ya ha pasado. No se puede programar un recordatorio para esta fecha.");
      return;
    }
    print(notificationDate);
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableLights: true,
      enableVibration: true,
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notifID,
      title,
      body,
      tz.TZDateTime.from(notificationDate, tz.local),
      // tz.TZDateTime.now(tz.local).add(
      //   const Duration(seconds: 5),
      // ),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    Get.snackbar("¡Recordatorio establecido!",
        "Se ha programado un recordatorio para el día $notificationDate.");
  }

  // initializeNotification() async {
  //   //tz.initializeTimeZones();
  //   // this is for latest iOS settings
  //   final DarwinInitializationSettings initializationSettingsIOS =
  //       DarwinInitializationSettings(
  //           requestSoundPermission: false,
  //           requestBadgePermission: false,
  //           requestAlertPermission: false,
  //           onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  //   final AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings("app_icon");

  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     iOS: initializationSettingsIOS,
  //     android: initializationSettingsAndroid,
  //   );
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onDidReceiveNotificationResponse: selectNotification);
  // }

  // displayNotification({required String title, required String body}) async {
  //   print("doing test");
  //   var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
  //       'channel id', 'channel name',
  //       importance: Importance.max, priority: Priority.high, playSound: true);
  //   var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //       iOS: iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'You change your theme',
  //     'You changed your theme back !',
  //     platformChannelSpecifics,
  //     payload: 'It could be anything you pass',
  //   );
  // }

  // Future onDidReceiveLocalNotification(
  //     int id, String? title, String? body, String? payload) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  //   // showDialog(
  //   //   //context: context,
  //   //   builder: (BuildContext context) => CupertinoAlertDialog(
  //   //     title: Text(title),
  //   //     content: Text(body),
  //   //     actions: [
  //   //       CupertinoDialogAction(
  //   //         isDefaultAction: true,
  //   //         child: Text('Ok'),
  //   //         onPressed: () async {
  //   //           Navigator.of(context, rootNavigator: true).pop();
  //   //           await Navigator.push(
  //   //             context,
  //   //             MaterialPageRoute(
  //   //               builder: (context) => SecondScreen(payload),
  //   //             ),
  //   //           );
  //   //         },
  //   //       )
  //   //     ],
  //   //   ),
  //   // );
  //   Get.dialog(Text("Welcome to Flutter"));
  // }

  // // Future selectNotification(String payload) async {
  // //   if (payload != null) {
  // //     print('notification payload: $payload');
  // //   } else {
  // //     print("Notification Done");
  // //   }
  // //   Get.to(() => Container(color: Colors.white));
  // // }
  // Future<void> selectNotification(NotificationResponse response) async {
  //   String? payload = response.payload;
  //   if (payload != null) {
  //     print('notification payload: $payload');
  //   } else {
  //     print("Notification Done");
  //   }
  //   Get.to(() => Container(color: Colors.white));
  // }
}
