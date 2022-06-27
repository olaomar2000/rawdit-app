import 'dart:async';
// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

var postUrl =
    "https://fcm.googleapis.com/v1/projects/flutter-f1249/messages:send";

Future<void> sendNotification() async {
  // var token = await getToken(receiver);
  //print('token : $token');

  final data = {
    "message": {
      "topic": "news",
      "notification": {
        "title": "Breaking News",
        "body": "New news story available."
      },
      "data": {"story_id": "story_12345"},
      "android": {
        "notification": {"click_action": "TOP_STORY_ACTIVITY"}
      },
    }
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization':
        'Bearer cRUS3WMyQi-n-sLZw3FpsU:APA91bEMnSR5sR2I84lOLPyfFvORhaXdxy7U24cQXeIFnv3owyfhtGhDWeF600QM34ZlteCp3TZLlO8kBeytLgLU0x5J2yFi2uqo2U_eZWiPcdE6VAtDPO0TDfpSprnr28tF7bjYCD1_'
  };

  BaseOptions options = new BaseOptions(
    connectTimeout: 5000,
    receiveTimeout: 3000,
    headers: headers,
  );

  try {
    final response = await Dio(options).post(postUrl, data: data);

    if (response.statusCode == 200) {
      print('Request Sent To Driver');
    } else {
      print('notification sending failed');
      // on failure do sth
    }
  } catch (e) {
    print('exception $e');
  }
}

// Future<String> getToken(userId) async {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   var token;
//   await _db.collection('users').get().then((snapshot) {
//     snapshot.docs.forEach((doc) {
//       token = doc.data();
//     });
//   });

//   return token;
// }

class login extends StatefulWidget {
  const login({Key key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  StreamSubscription iosSubscription;
  @override
  initState() {
    super.initState();
    sendNotification();
    onMessage:
    (Map<String, dynamic> message) async {
      print("onMessage: $message");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ListTile(
            title: Text(message['notification']['title']),
            subtitle: Text(message['notification']['body']),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    };
    onLaunch:
    (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      // TODO optional
    };
    onResume:
    (Map<String, dynamic> message) async {
      print("onResume: $message");
      // TODO optional
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
