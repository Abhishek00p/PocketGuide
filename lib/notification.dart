import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifiServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      AndroidInitializationSettings("@mipmap/launcher_icon");

  void initializeNotification() async {
    InitializationSettings initializationSettings =
        InitializationSettings(android: _androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void sendnotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channelId", "channelName",
            icon: "@mipmap/launcher_icon",
            importance: Importance.max,
            priority: Priority.high);
    final _notificationdetail = NotificationDetails();
    _flutterLocalNotificationsPlugin.show(0, title, body, _notificationdetail);
  }
}
