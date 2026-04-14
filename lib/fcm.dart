import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initialize({required void Function(RemoteMessage) onData}) async {
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final token = await messaging.getToken();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('FCM token: $token');
    } else {
      debugPrint('FCM permission not granted: ${settings.authorizationStatus}');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onData(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onData(message);
    });

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      onData(initialMessage);
    }
  }

  Future<String?> getToken() {
    return messaging.getToken();
  }
}