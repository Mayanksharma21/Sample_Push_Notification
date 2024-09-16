import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:testapplication/firebase_options.dart';
import 'package:testapplication/services/notificaton_service.dart';

// Function to Listen to Background Changes
Future _firebaseBackgroundMessageHandler(RemoteMessage remoteMessage) async {
  if (remoteMessage.notification != null) {
    log('Some Notification Received in Background');
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Firebase Messaging
  await PushNotifications.init();

  // Initialize Local Notification
  await PushNotifications.localNotificationInit();

  // Listen to Background Notification
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);

  // Listen to Foreground Notification
  FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
    String payloadData = jsonEncode(remoteMessage.data);

    if( remoteMessage.notification != null) {
      PushNotifications.showLocalNotification(title: remoteMessage.notification!.title!, body: remoteMessage.notification!.body!, payload: payloadData);
    }
  });

  // Listen to Terminated Notification
  final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Testing Application',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Notifications'),
      ),
      body: const Center(
        child: Text('Notification Testing App'),
      ),
    );
  }
}


