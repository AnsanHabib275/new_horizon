// ignore_for_file: use_build_context_synchronously, unused_local_variable, unused_import

import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

class NotificationServices {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  // final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    if (!kIsWeb) {
      // final InitializationSettings initializationSettings =
      //     InitializationSettings(
      //       android:
      //           Platform.isAndroid
      //               ? const AndroidInitializationSettings('@mipmap/ic_launcher')
      //               : null,
      //       iOS: Platform.isIOS ? const DarwinInitializationSettings() : null,
      //     );
      // if (!kIsWeb) {
      //   // Declare variables outside conditionals
      //   late AndroidInitializationSettings initializationSettingsAndroid;
      //   late DarwinInitializationSettings initializationSettingsIOS;
      //
      //   if (Platform.isAndroid) {
      //     initializationSettingsAndroid = const AndroidInitializationSettings(
      //       '@mipmap/ic_launcher',
      //     );
      //   }
      //
      //   if (Platform.isIOS) {
      //     initializationSettingsIOS = const DarwinInitializationSettings();
      //   }
      //
      //   final InitializationSettings initializationSettings =
      //       InitializationSettings(
      //         android: Platform.isAndroid ? initializationSettingsAndroid : null,
      //         iOS: Platform.isIOS ? initializationSettingsIOS : null,
      //       );
      //
      //   await FlutterLocalNotificationsPlugin().initialize(
      //     initializationSettings,
      //   );
    }
  }

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  // void initLocalNotifications(
  //   BuildContext context,
  //   RemoteMessage message,
  // ) async {
  //   var androidInitializationSettings = const AndroidInitializationSettings(
  //     '@mipmap/ic_launcher',
  //   );
  //   var iosInitializationSettings = const DarwinInitializationSettings();
  //
  //   var initializationSetting = InitializationSettings(
  //     android: androidInitializationSettings,
  //     iOS: iosInitializationSettings,
  //   );
  //
  //   await _flutterLocalNotificationsPlugin.initialize(
  //     initializationSetting,
  //     onDidReceiveNotificationResponse: (payload) {
  //       // handle interaction when app is active for android
  //       handleMessage(context, message);
  //     },
  //   );
  // }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        // print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        // initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    // AndroidNotificationChannel channel = AndroidNotificationChannel(
    //   message.notification!.android!.channelId.toString(),
    //   message.notification!.android!.channelId.toString(),
    //   importance: Importance.max,
    //   showBadge: true,
    //   playSound: true,
    //   // sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
    // );
    //
    // AndroidNotificationDetails androidNotificationDetails =
    //     AndroidNotificationDetails(
    //       channel.id.toString(),
    //       channel.name.toString(),
    //       channelDescription: 'your channel description',
    //       importance: Importance.high,
    //       priority: Priority.high,
    //       playSound: true,
    //       ticker: 'ticker',
    //       sound: channel.sound,
    //       //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
    //       //  icon: largeIconPath
    //     );
    //
    // const DarwinNotificationDetails darwinNotificationDetails =
    //     DarwinNotificationDetails(
    //       presentAlert: true,
    //       presentBadge: true,
    //       presentSound: true,
    //     );
    //
    // NotificationDetails notificationDetails = NotificationDetails(
    //   android: androidNotificationDetails,
    //   iOS: darwinNotificationDetails,
    // );
    //
    // Future.delayed(Duration.zero, () {
    //   _flutterLocalNotificationsPlugin.show(
    //     0,
    //     message.notification!.title.toString(),
    //     message.notification!.body.toString(),
    //     notificationDetails,
    //   );
    // });
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['1001'] == 'msj') {
      log('message');
    }
  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}
