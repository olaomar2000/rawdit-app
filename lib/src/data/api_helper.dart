import 'dart:convert';

import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/models/attendance.dart';
import 'package:arabi/src/models/homework.dart';
import 'package:arabi/src/models/notification.dart';
import 'package:arabi/src/models/post.dart';
import 'package:arabi/src/models/section.dart';
import 'package:arabi/src/models/student.dart';
import 'package:arabi/src/models/submit.dart';
import 'package:arabi/src/models/teacher.dart';
import 'package:arabi/src/notifications/notification_http.dart';
import 'package:arabi/src/utils/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
// import 'package:overlay_support/overlay_support.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  ApiHelper._();
  static ApiHelper apiHelper = ApiHelper._();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> updateNotificationId(String userType) async {
    await messaging.getToken().then((value) async {
      DatabaseReference ref = FirebaseDatabase.instance
          .ref("$userType/${await SPHelper.spHelper.getUId()}");
      SPHelper.spHelper.setToken(value);
      await ref.update({
        "notification_id": value,
      });
    });
  }

  Future<void> removeNotificationId(String userType) async {
    String uid = await SPHelper.spHelper.getUId();
    await messaging.getToken().then((value) async {
      DatabaseReference ref = FirebaseDatabase.instance.ref("$userType/$uid");
      SPHelper.spHelper.setToken(value);
      await ref.child(uid).remove();
    });
  }

  Future<List<students>> getAllStudents() async {
    http.Response res = await http.get(Uri.parse(Constants.STUDENT_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return [];
    }
    final List<students> allStudents = [];
    extractedData.forEach((stdId, stdData) {
      allStudents.add(students(
        id: stdId,
        address: stdData['address'],
        email: stdData['email'],
        gender: stdData['gender'],
        identificationNumber: stdData['identification_number'],
        image: stdData['image'],
        lat: stdData['lat'],
        long: stdData['long'],
        name: stdData['name'],
        notificationId: stdData['notification_id'],
        password: stdData['password'],
        phone: stdData['phone'],
        section: stdData['section'],
        studentQr: stdData['student_qr'],
      ));
    });
    return allStudents;
  }

  Future getAllSections(String tecId) async {
    http.Response res = await http.get(Uri.parse(Constants.SECTION_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    sections sec;
    extractedData.forEach((secId, secData) {
      if (secData['teacher_id'] == tecId) {
        sec = sections(
            id: secId,
            name: secData['name'],
            category: secData['category'],
            teacherId: secData['teacher_id']);
      }
    });
    return sec;
  }

  Future getAllPosts(String tecId) async {
    http.Response res = await http.get(Uri.parse(Constants.POST_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<Post> allPost = [];
    extractedData.forEach((postId, postData) {
      if (postData['teacherId'] == tecId) {
        allPost.insert(
            0,
            Post(
                id: postId,
                content: postData['content'],
                date: postData['date'],
                teacherId: postData['teacherId']));
      }
    });
    return allPost;
  }

  Future getStudentInSecation(String SecId) async {
    http.Response res = await http.get(Uri.parse(Constants.STUDENT_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<students> StudentInSecation = [];
    extractedData.forEach((stdId, stdData) {
      if (stdData['section'] == SecId) {
        StudentInSecation.add(students(
          id: stdId,
          address: stdData['address'],
          email: stdData['email'],
          gender: stdData['gender'],
          identificationNumber: stdData['identification_number'],
          image: stdData['image'],
          lat: stdData['lat'],
          long: stdData['long'],
          name: stdData['name'],
          notificationId: stdData['notification_id'],
          password: stdData['password'],
          phone: stdData['phone'],
          section: stdData['section'],
          studentQr: stdData['student_qr'],
        ));
      }
    });
    return StudentInSecation;
  }

  Future<String> submitAuthForm(
      String password, String id, bool isLogin, String Url) async {
    String uid = "fail";

    try {
      http.Response res = await http.get(Uri.parse(Url));
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      extractedData.forEach((stdId, stdData) {
        if (stdData['identification_number'] == id &&
            stdData['password'] == password) {
          uid = stdId;
          SPHelper.spHelper.setUId(uid);
          SPHelper.spHelper
              .addKey('type', Constants.TEACHER_URL == Url ? 'teacher' : 'std');
          SPHelper.spHelper.addKey('remembered', '$isLogin');
          return;
        }
      });
      return uid;
    } catch (error) {
      throw error;
    }
  }

  Future<teachers> getTeacher() async {
    http.Response res = await http.get(Uri.parse(Constants.TEACHER_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    String uid = await SPHelper.spHelper.getUId();

    teachers tec;
    extractedData.forEach((tecId, tecData) async {
      if (tecId == uid) {
        tec = teachers(
          id: tecId,
          email: tecData['email'],
          gender: tecData['gender'],
          identificationNumber: tecData['identification_number'],
          inBus: tecData['in_bus'],
          name: tecData['name'],
          notificationId: tecData['notification_id'],
          password: tecData['password'],
          phone: tecData['phone'],
          teacherQr: tecData['teacher_qr'],
        );
        return tec;
      }
    });
    return tec;
  }

  final DatabaseReference _postRef =
      FirebaseDatabase.instance.reference().child('posts');
  Future addPost(Post post) async {
    try {
      await _postRef.push().set(post.toMap());
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> deletePost(String id) async {
    try {
      await _postRef.child(id).remove();
    } on Exception catch (e) {
      print(e);
    }
  }

  /// Start Notifications

  Future<void> sendNotificatonToallStudent(
      String secId, String title, String body) async {
    http.Response res = await http.get(Uri.parse(Constants.STUDENT_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    await extractedData.forEach((stdId, stdData) async {
      if (stdData['section'] == secId) {
        await NotificationService().sendFcm(
            title: title, body: body, fcmToken: stdData['notification_id']);
        return;
      }
    });
  }

  Future<void> sendNotificatonStudent(
      String studentId, String title, String body) async {
    http.Response res = await http.get(Uri.parse(Constants.STUDENT_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    await extractedData.forEach((stdId, stdData) async {
      if (stdId == studentId) {
        await NotificationService().sendFcm(
            title: title, body: body, fcmToken: stdData['notification_id']);
        return;
      }
    });
  }

  final DatabaseReference _notificationRef =
      FirebaseDatabase.instance.reference().child('notifications');

  Future addnotification(Notifications notification) async {
    try {
      await _notificationRef.push().set(notification.toMap());
    } on Exception catch (e) {
      print(e);
    }
  }

  Future getAllNotifications(String id) async {
    http.Response res = await http.get(Uri.parse(Constants.Notifications_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<Notifications> allNotification = [];
    await extractedData.forEach((notificationId, notificationData) async {
      if (notificationData['receiverId'] == id ||
          notificationData['receiverId'] == await SPHelper.spHelper.getUId()) {
        allNotification.insert(
            0,
            Notifications(
                id: notificationId,
                text: notificationData['text'],
                senderId: notificationData['senderId'],
                receiverId: notificationData['receiverId'],
                date: notificationData['date'],
                isClicked: notificationData['isClicked']));
      }
    });
    return allNotification;
  }

  Future<void> deleteNotification(String id) async {
    try {
      await _notificationRef.child(id).remove();
    } on Exception catch (e) {
      print(e);
    }
  }

  /// end Notifications

// START STUDENT METHODS

  Future<List<students>> getAllStudentsatTheSameSection(String secId) async {
    http.Response res = await http.get(Uri.parse(Constants.STUDENT_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }
    final List<students> allStd = [];
    extractedData.forEach((stdId, stdData) {
      if (stdData['section'] == secId) {
        allStd.add(students(
            id: stdId,
            address: stdData['address'],
            email: stdData['email'],
            gender: stdData['gender'],
            identificationNumber: stdData['identification_number'],
            image: stdData['image'],
            name: stdData['name'],
            lat: stdData['lat'],
            long: stdData['long'],
            notificationId: stdData['notification_id'],
            password: stdData['password'],
            phone: stdData['phone'],
            section: stdData['section'],
            studentQr: stdData['student_qr']));
      }
    });
    return allStd;
  }

  Future<students> getLoginStudent() async {
    http.Response res = await http.get(Uri.parse(Constants.STUDENT_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    String uid = await SPHelper.spHelper.getUId();
    students std;
    extractedData.forEach((tecId, tecData) async {
      if (tecId == uid) {
        std = students(
            id: tecId,
            address: tecData['address'],
            email: tecData['email'],
            gender: tecData['gender'],
            identificationNumber: tecData['identification_number'],
            image: tecData['image'],
            name: tecData['name'],
            lat: tecData['lat'],
            long: tecData['long'],
            notificationId: tecData['notification_id'],
            password: tecData['password'],
            phone: tecData['phone'],
            section: tecData['section'],
            studentQr: tecData['student_qr']);
      }
    });
    return std;
  }

  Future<sections> getSectionInfoById() async {
    students std = await getLoginStudent();
    http.Response res = await http.get(Uri.parse(Constants.SECTION_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    sections section;

    extractedData.forEach((secId, secData) {
      if (secId == std.section) {
        section = sections(
            id: secId,
            name: secData['name'],
            category: secData['category'],
            teacherId: secData['teacher_id']);
      }
    });
    return section;
  }

  Future<List<Post>> getAllPostInStudent() async {
    sections sec = await getSectionInfoById();
    http.Response res = await http.get(Uri.parse(Constants.POST_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return [];
    }
    final List<Post> allPost = [];
    extractedData.forEach((postId, postData) {
      if (postData['teacherId'] == sec.teacherId) {
        allPost.insert(
            0,
            Post(
                id: postId,
                content: postData['content'],
                date: postData['date'],
                teacherId: postData['teacherId']));
      }
    });
    return allPost;
  }

  Future<teachers> getTeacherInfo() async {
    sections sec = await getSectionInfoById();

    http.Response res = await http.get(Uri.parse(Constants.TEACHER_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    teachers teacher;

    extractedData.forEach((tecId, tecData) {
      if (tecId == sec.teacherId) {
        teacher = teachers(
          id: tecId,
          email: tecData['email'],
          gender: tecData['gender'],
          identificationNumber: tecData['identification_number'],
          inBus: tecData['in_bus'],
          name: tecData['name'],
          notificationId: tecData['notification_id'],
          password: tecData['password'],
          phone: tecData['phone'],
          teacherQr: tecData['teacher_qr'],
        );
      }
    });
    return teacher;
  }

  Future<bool> logStudentWithQr(String resultQR) async {
    bool reslut = false;
    http.Response res = await http.get(Uri.parse(Constants.STUDENT_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return false;
    }

    extractedData.forEach((stdId, stdData) {
      if (stdId == resultQR) {
        SPHelper.spHelper.setUId(stdId);
        reslut = true;
      }
    });
    return reslut;
  }

  Future<bool> logTeacherWithQr(String resultQR) async {
    bool reslut = false;
    http.Response res = await http.get(Uri.parse(Constants.TEACHER_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return false;
    }

    extractedData.forEach((teacherId, teachreData) {
      if (teacherId == resultQR) {
        SPHelper.spHelper.setUId(teacherId);
        reslut = true;
      }
    });
    return reslut;
  }

//homework teacher
  final DatabaseReference _homeworkRef =
      FirebaseDatabase.instance.reference().child('homework');
  Future addHomework(Homework homework) async {
    try {
      await _homeworkRef.push().set(homework.toMap());
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> editHomework(Homework homework) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("homework/${homework.id}");
    try {
      await ref.update(homework.toMap());
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<List<Homework>> getAllhomework(String tecId) async {
    http.Response res = await http.get(Uri.parse(Constants.HomeWork_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return [];
    }
    final List<Homework> allHomework = [];
    extractedData.forEach((homeworkId, homeworkData) {
      if (homeworkData['teacherId'] == tecId) {
        allHomework.insert(
            0,
            Homework(
                id: homeworkId,
                teacherId: homeworkData['teacherId'],
                title: homeworkData['title'],
                description: homeworkData['description'],
                endDate: homeworkData['endDate'],
                fileUrl: homeworkData['fileUrl']));
      }
    });
    return allHomework;
  }

// the input is the all hw for the submitted and not
  Future<Map<String, List<Homework>>> getSubmittedAndUnSubmittedhomework(
      List<Homework> allHW) async {
    List<Submit> submitted = [];
    List<String> submitHwIds = [];
    List<Homework> unSubmittedHwIds = [];
    List<Homework> submittedHwIds = [];
    List<Homework> missedHandingHwIds = [];

    Map<String, List<Homework>> data = {};

    http.Response res = await http.get(Uri.parse(Constants.Submit_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;

    String uid = await SPHelper.spHelper.getUId();
    (extractedData ?? {}).forEach((subId, submitData) {
      if (submitData['stdId'] == uid) {
        submitHwIds.add(submitData['homeworkId']);
        submitted.add(
          Submit(
            mark: submitData['mark'],
            file: submitData['file'],
            note: submitData['note'],
            homeworkId: submitData['homeworkId'],
            id: submitData['id'],
            stdId: submitData['stdId'],
          ),
        );
      }
    });

    allHW.forEach((e) {
      bool _missedTheDeadline = false;
      List<String> date;
      String hwDate = e.endDate;
      if (hwDate.contains('T')) {
        hwDate = hwDate.substring(0, hwDate.indexOf('T'));
      } else if (hwDate.contains(' ')) {
        hwDate = hwDate.substring(0, hwDate.indexOf(' '));
      }
      if (hwDate.contains('-')) {
        date = hwDate.split('-');
      } else if (hwDate.contains('/')) {
        date = hwDate.split('/');
      }

      if (int.parse(date[1]) >= DateTime.now().month &&
          int.parse(date[2]) >= DateTime.now().day) {
        _missedTheDeadline = false;
      } else {
        _missedTheDeadline = true;
      }

      if (submitHwIds.indexOf(e.id) == -1) {
        if (_missedTheDeadline) {
          missedHandingHwIds.add(e);
        } else {
          unSubmittedHwIds.add(e);
        }
      } else {
        submittedHwIds.add(e);
      }
    });

    data = {
      "submittedIdsHw": submittedHwIds,
      "unSubmittedHwIds": unSubmittedHwIds,
      "missedHandingHwIds": missedHandingHwIds,
    };

    return data;
  }

  Future<void> deleteHomework(String id) async {
    try {
      await _homeworkRef.child(id).remove();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> deleteAllSubmitterForThisHomework(String idHW) async {
    http.Response res = await http.get(Uri.parse(Constants.Submit_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return {};
    }

    await extractedData.forEach((submitId, submitData) async {
      if (submitData['homeworkId'] == idHW) {
        await deleteSubmit(submitId);
      }
    });
  }

  Future<Homework> getHomeworkDetalis(String id) async {
    http.Response res = await http.get(Uri.parse(Constants.HomeWork_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }
    Homework homework;
    extractedData.forEach((homeworkId, homeworkData) {
      if (homeworkId == id) {
        homework = Homework(
            id: homeworkId,
            teacherId: homeworkData['teacherId'],
            title: homeworkData['title'],
            description: homeworkData['description'],
            endDate: homeworkData['endDate'],
            fileUrl: homeworkData['fileUrl']);
      }
    });
    return homework;
  }

// end homework teacher

// Start submit

  final DatabaseReference _submitRef =
      FirebaseDatabase.instance.reference().child('submit');
  Future addSubmit(Submit sub) async {
    try {
      await _submitRef.push().set(sub.toMap());
    } on Exception catch (e) {
      print(e);
    }
  }

  Future getAllSumbmiters(String homeworkId) async {
    http.Response res = await http.get(Uri.parse(Constants.Submit_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<Submit> allsubmit = [];
    extractedData.forEach((submitId, submitData) {
      if (submitData['homeworkId'] == homeworkId) {
        allsubmit.add(Submit(
          id: submitId,
          stdId: submitData['stdId'],
          homeworkId: submitData['homeworkId'],
          mark: submitData['mark'],
          file: submitData['file'],
          note: submitData['note'],
        ));
      }
    });
    return allsubmit;
  }

  Future<Submit> getSubmitDetalisForTheHW(String idHw) async {
    http.Response res = await http.get(Uri.parse(Constants.Submit_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }
    Submit sub;
    extractedData.forEach((subId, submitData) {
      if (submitData['homeworkId'] == idHw) {
        sub = Submit(
          id: subId,
          stdId: submitData['stdId'],
          homeworkId: submitData['homeworkId'],
          mark: submitData['mark'],
          file: submitData['file'],
          note: submitData['note'],
        );
        return sub;
      }
    });
    return sub;
  }

  Future<void> deleteSubmit(String id) async {
    try {
      await _submitRef.child(id).remove();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<students> getStd(String stdId) async {
    http.Response res = await http.get(Uri.parse(Constants.STUDENT_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    students std;
    extractedData.forEach((studentId, stdData) async {
      if (studentId == stdId) {
        std = students(
            id: studentId,
            address: stdData['address'],
            email: stdData['email'],
            gender: stdData['gender'],
            identificationNumber: stdData['identification_number'],
            image: stdData['image'],
            name: stdData['name'],
            lat: stdData['lat'],
            long: stdData['long'],
            notificationId: stdData['notification_id'],
            password: stdData['password'],
            phone: stdData['phone'],
            section: stdData['section'],
            studentQr: stdData['student_qr']);
      }
    });
    return std;
  }

  Future<void> addMarkAndNote(String idSubmit, String mark, String note) async {
    DatabaseReference ref =
        await FirebaseDatabase.instance.ref("submit/$idSubmit");

    await ref.update({
      "mark": mark,
      "note": note,
    });
  }

  /// end submit
  ///

  /// start attebdance

  final DatabaseReference _attendanceRef =
      FirebaseDatabase.instance.reference().child('attendances');
  Future<void> addAttendance(Attendance attendance) async {
    try {
      await _attendanceRef.push().set(attendance.toMap());
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> deleteAttendance(String id) async {
    try {
      await _attendanceRef.child(id).remove();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<List<Attendance>> getAllTodayAttendances() async {
    http.Response res = await http.get(Uri.parse(Constants.Attendances_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return [];
    }
    final List<Attendance> allAttendance = [];
    String date = DateTime.now().year.toString() +
        "/" +
        DateTime.now().month.toString() +
        "/" +
        DateTime.now().day.toString();

    extractedData.forEach((AttId, attendanceData) {
      if (date == attendanceData['date']) {
        allAttendance.add(Attendance(
          id: AttId,
          stdId: attendanceData['stdId'],
          singout: attendanceData['singout'],
          date: attendanceData['date'],
        ));
      }
    });

    return allAttendance;
  }

  Future<students> TakeAttendanceWithQr(String resultQR) async {
    http.Response res = await http.get(Uri.parse(Constants.STUDENT_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }

    students std;

    extractedData.forEach((stdId, stdData) {
      if (stdId == resultQR) {
        std = students(
            id: stdId,
            address: stdData['address'],
            email: stdData['email'],
            gender: stdData['gender'],
            identificationNumber: stdData['identification_number'],
            image: stdData['image'],
            name: stdData['name'],
            lat: stdData['lat'],
            long: stdData['long'],
            notificationId: stdData['notification_id'],
            password: stdData['password'],
            phone: stdData['phone'],
            section: stdData['section'],
            studentQr: stdData['student_qr']);
      }
    });

    return std;
  }

  Future<Attendance> existAttendance(String stdId, String date) async {
    http.Response res = await http.get(Uri.parse(Constants.Attendances_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return null;
    }
    Attendance attendance;
    extractedData.forEach((attendanceId, AttendanceData) async {
      if (AttendanceData['stdId'] == stdId && AttendanceData['date'] == date) {
        attendance = Attendance(
            id: attendanceId,
            date: date,
            stdId: stdId,
            singout: AttendanceData['singout']);
        return attendance;
      }
    });
    return attendance;
  }

  Future<void> editAttendance(Attendance att) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("attendances/${att.id}");
    try {
      await ref.update({
        "singout": att.singout,
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  /// end attendance

  /// start map

  Future updateLatLng(String idTech, LocationData location) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("teachers/$idTech");

    await ref.update({
      "lat": location.latitude,
      "long": location.longitude,
    });
  }

  Future<teachers> getTeacherInBus() async {
    http.Response res = await http.get(Uri.parse(Constants.TEACHER_URL));
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    teachers teacher;

    extractedData.forEach((tecId, tecData) async {
      if (tecData['in_bus'] == true) {
        teacher = teachers(
          id: tecId,
          email: tecData['email'],
          gender: tecData['gender'],
          identificationNumber: tecData['identification_number'],
          inBus: tecData['in_bus'],
          name: tecData['name'],
          notificationId: tecData['notification_id'],
          password: tecData['password'],
          phone: tecData['phone'],
          teacherQr: tecData['teacher_qr'],
        );
      }
    });
    return teacher;
  }

  Future<void> updateInBus(String idTech, bool in_bus) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("teachers/$idTech");

    await ref.update({
      "in_bus": in_bus,
    });
  }
// end map
}
