import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.showLocalNotificationFromFCM(message);
}

class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<void> init() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    final token = await _fcm.getToken();
    print('FCM TOKEN: $token');

    await localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleClick(response.payload);
      },
    );

    // Foreground Condition
    FirebaseMessaging.onMessage.listen((message) {
      showLocalNotificationFromFCM(message);
    });

    // Background Codition
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleClick(jsonEncode(message.data));
    });

    // Terminated Condition
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleClick(jsonEncode(initialMessage.data));
    }
  }

  static Future<void> showLocalNotificationFromFCM(
    RemoteMessage message,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'push_channel',
      'Push Notification',
      channelDescription: 'Push with custom sound',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('custom_sound'),
      playSound: true,
    );

    await localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? '',
      const NotificationDetails(android: androidDetails),
      payload: jsonEncode(message.data),
    );
  }

  static Future<void> showLocalNotification({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'local_channel',
      'Local Notification',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('custom_sound'),
    );

    await localNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails),
      payload: jsonEncode(payload),
    );
  }

  static void _handleClick(String? payload) {
    if (payload == null) return;

    final data = jsonDecode(payload);

    switch (data['type']) {
      case 'order-detail':
        Get.toNamed('/order-detail', arguments: data);
        break;
      case 'home':
      default:
        Get.offAllNamed('/home');
    }
  }
}
