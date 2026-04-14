import 'package:cloud_messaging/fcm.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();
  String statusText = 'Waiting for a cloud message';
  String imagePath = 'assets/images/default.png';

  @override
  void initState() {
    super.initState();
    _fcmService.initialize(onData: (message) {
      final asset = (message.data['asset'] ?? 'default').toString();
      final action = (message.data['action'] ?? '').toString();

      setState(() {
        statusText =
            message.notification?.title ??
            (action.isNotEmpty ? 'Action: $action' : 'Payload received');
        imagePath = 'assets/images/$asset.png';

        if (action == 'show_animation') {
          statusText = 'Showing promo animation';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Messaging'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              statusText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Image not found in assets/images/');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}