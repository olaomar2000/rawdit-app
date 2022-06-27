import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  String id;
  String text;
  String date;
  String senderId;
  String receiverId;
  bool isClicked;

  Notifications(
      {this.id,
      this.text,
      this.date,
      this.senderId,
      this.receiverId,
      this.isClicked = false});

  toMap() {
    return {
      'id': id,
      'text': text,
      'date': date,
      'senderId': senderId,
      'receiverId': receiverId,
      'isClicked': isClicked
    };
  }
}
