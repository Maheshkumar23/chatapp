import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:orange_ui/utils/const_res.dart';

class FirebaseNotificationManager {
  static var shared = FirebaseNotificationManager();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'orange', // id
      'Orange', // title
      playSound: true,
      enableLights: true,
      enableVibration: true,
      showBadge: false,
      importance: Importance.max);

  FirebaseNotificationManager() {
    init();
  }

  void init() async {
    // subscribeToTopic(null);
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, sound: true);
    }

    await firebaseMessaging.requestPermission(alert: true, badge: false, sound: true);

    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = const DarwinInitializationSettings(
        defaultPresentAlert: true, defaultPresentSound: true, defaultPresentBadge: false);

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('${message.notification?.toMap()}');
      showNotification(message);
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void showNotification(RemoteMessage message) {
    flutterLocalNotificationsPlugin.show(
      1,
      message.data['title'] ?? message.notification?.title,
      message.data['body'] ?? message.notification?.body,
      NotificationDetails(
          iOS: const DarwinNotificationDetails(presentSound: true, presentAlert: true, presentBadge: false),
          android: AndroidNotificationDetails(channel.id, channel.name)),
    );
  }

  void getNotificationToken(Function(String token) completion) async {
    try {
      await FirebaseMessaging.instance.getToken().then((value) {
        log(
          'DeviceToken : $value',
        );
        completion(value ?? 'No Token');
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void unsubscribeToTopic() async {
    log('Topic UnSubscribe');
    await firebaseMessaging.unsubscribeFromTopic('${ConstRes.subscribeTopic}_${Platform.isIOS ? 'ios' : 'android'}');
  }
}
