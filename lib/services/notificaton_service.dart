import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotifications {
  // Firebase Messaging Instance
  static final _firebaseMessaging = FirebaseMessaging.instance;

  // Flutter Local Notifications Instance
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Request Notification Permission
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true
    );

    // Get The Device Token
    final deviceToken = await _firebaseMessaging.getToken();

    log('########Device Token => $deviceToken #############');
  }

  // Initialize Local Notification
  static Future localNotificationInit()async{
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher'
    );

    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null
    );

    const LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: "Open notification");

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux
    );

    // Request Notification Permission on Android 13 and above
    _flutterLocalNotificationsPlugin .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTapHandler,
      onDidReceiveBackgroundNotificationResponse: onNotificationTapHandler
    );
  }

  static void onNotificationTapHandler(NotificationResponse notificationResponse) {}

  // Show Local Notification for Foreground Notification
  static Future showLocalNotification({
    required String title,
    required String body,
    required String payload
}) async{
  const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    'Your Channel Id',
    "Your Channel Name",
    channelDescription: "Your Channel Description",
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker'
  );

  const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
  
  await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: payload);
  }
}