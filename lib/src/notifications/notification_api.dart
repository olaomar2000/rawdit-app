import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'descriptions',
        importance: Importance.high,
        icon: "mipmap/ic_launcher",
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future<void> showNotification({
    int id = 0,
    String title,
    String body,
    String payload,
  }) async =>
      _notification.show(id, title, body, await _notificationDetails(),
          payload: payload);
}
