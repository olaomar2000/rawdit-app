import 'dart:convert';
import 'dart:io';

import 'package:arabi/src/notifications/notification_api.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final HttpClient httpClient = HttpClient();
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  final fcmKey =
      "AAAA6f-KEIQ:APA91bH3N8rtjhsXXKJPnKCVxAzeTrgM9fGuXb8D1KDAMiqpLcaXsbZPOJQUq-MGwKVZrmp8XNlURNWLbY7ZRPlk5K9Brdd577xAHIfAOI_B48-x6-ZFFn7QO9H4VTKxbKJtGOJ-T1Xn";

  Future<void> sendFcm({
    String title,
    String body,
    String fcmToken,
  }) async {
    var response = await http.post(Uri.parse(fcmUrl),
        body: jsonEncode({
          "to": fcmToken,
          "priority": "high",
          "notification": {"title": title, "body": body}
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmKey'
        });

    if (response.statusCode == 200) {
      print(response.body.toString());

     await NotificationApi.showNotification(
          title: title, body: body, payload: "rawdti app");
    } else {
      print(response.reasonPhrase);
    }
  }
}

Future<void> sendNotificationsTime() async {
  await Future.delayed(const Duration(seconds: 5));
  await NotificationService().sendFcm(
      title: "hi there",
      body: "where are you from",
      fcmToken:
          "cRUS3WMyQi-n-sLZw3FpsU:APA91bEMnSR5sR2I84lOLPyfFvORhaXdxy7U24cQXeIFnv3owyfhtGhDWeF600QM34ZlteCp3TZLlO8kBeytLgLU0x5J2yFi2uqo2U_eZWiPcdE6VAtDPO0TDfpSprnr28tF7bjYCD1_");
}
