import 'dart:io';

import 'package:arabi/src/data/api_helper.dart';
import 'package:arabi/src/data/firestorage_helper.dart';
import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/models/attendance.dart';
import 'package:arabi/src/models/homework.dart';
import 'package:arabi/src/models/notification.dart';
import 'package:arabi/src/models/post.dart';
import 'package:arabi/src/models/section.dart';
import 'package:arabi/src/models/student.dart';
import 'package:arabi/src/models/submit.dart';
import 'package:arabi/src/models/teacher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:overlay_support/overlay_support.dart';

import '../view/screens/full_image_screen.dart';
import '../view/screens/show_video_screen.dart';

class TeacherMainScreenNotifiers with ChangeNotifier {
  // ||....................... notifiable ..................................||
  bool isHomeScreen = true;
  bool navigateFromCategory = false;
  List<students> allStd = [];

  // ||...................... logic methods ............................||

  bool hide = true;

  ScrollController scrollBottomBarController =
      new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;

  void myScroll() {
    scrollBottomBarController.addListener(() {
      if (scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          hideBottomBar();
        }
      }
      if (scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          showBottomBar();
        }
      }
    });
  }

  void showBottomBar() {
    hide = true;
    notifyListeners();
  }

  void hideBottomBar() {
    hide = false;
    notifyListeners();
  }

  String getTheNameOfTheFile(String linkOfPhoto, bool isLandScape) {
    String tmp = "";
    if (linkOfPhoto != 'file' && linkOfPhoto.contains('?')) {
      tmp = linkOfPhoto
          .substring(0, linkOfPhoto.indexOf('?'))
          .substring(linkOfPhoto.lastIndexOf('/') + 1)
          .replaceAll('%2F', ' ');
      if (isLandScape && tmp.length > 25) {
        return tmp.substring(0, 25) + "...";
      } else if (isLandScape) {
        return tmp;
      } else {
        // not landScape
        if (tmp.length > 12) return tmp.substring(0, 12) + "...";
        return tmp;
      }
    } else if (linkOfPhoto != 'file') {
      tmp = linkOfPhoto
          .substring(linkOfPhoto.lastIndexOf('/') + 1)
          .replaceAll('%2F', ' ');
      if (isLandScape && tmp.length > 25) {
        return tmp.substring(0, 25) + "...";
      } else if (isLandScape) {
        return tmp;
      } else {
        // not landScape
        if (tmp.length > 12) return tmp.substring(0, 12) + "...";
        return tmp;
      }
    }
    return 'لا يوجد ملفات مرفقة';
  }

  Future<void> showTheFile(String file, BuildContext context) async {
    if (file != 'file') {
      if (file.contains(".mp4")) {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                ShowVideoScreen(src: file, tag: file),
          ),
        );
      } else {
        try {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  FullImage(src: file, tag: file),
            ),
          );
        } on Exception catch (_) {
          toast('لا يمكن عرض هذا الملف');
        }
      }
    }
  }
  // START logic methods for teacher user

  Future<void> sendNotidication(
      String studentId, String title, String body) async {
    await ApiHelper.apiHelper.sendNotificatonStudent(studentId, title, body);
  }

  sections sec;
  Future<void> getAllSection() async {
    sec = await ApiHelper.apiHelper
        .getAllSections(await SPHelper.spHelper.getUId());
    notifyListeners();
  }

  List<Post> allPost = [];
  Future<void> getAllPost() async {
    allPost = await ApiHelper.apiHelper
            .getAllPosts(await SPHelper.spHelper.getUId()) ??
        [];

    notifyListeners();
  }

  List<Attendance> allTodayAttendances = [];
  Future<void> getAllTodayAttendances() async {
    allTodayAttendances = await ApiHelper.apiHelper.getAllTodayAttendances();
    notifyListeners();
  }

  List<students> studentInSecation = [];
  Future<void> getStudentInSecation(String secId) async {
    studentInSecation = await ApiHelper.apiHelper.getStudentInSecation(secId);
    notifyListeners();
  }

  teachers teacher;
  Future<void> getTeacherInfo() async {
    teacher = await ApiHelper.apiHelper.getTeacher();
    notifyListeners();
  }

  Future<void> sendNotificatonToallStudent(
      String secId, String title, String body) async {
    await ApiHelper.apiHelper.sendNotificatonToallStudent(secId, title, body);
    notifyListeners();
  }

  Future<void> sendNotificatonStudent(
      String studentID, String title, String body) async {
    await ApiHelper.apiHelper.sendNotificatonStudent(studentID, title, body);
    notifyListeners();
  }

  Future<void> addPost(String content, String teacherId) async {
    final String now = new DateTime.now().toIso8601String();
    Post post = Post(content: content, date: now, teacherId: teacherId);
    await ApiHelper.apiHelper.addPost(post);
    allPost.insert(0, post);
    notifyListeners();
  }

  Future<void> deletePost(String id) async {
    await ApiHelper.apiHelper.deletePost(id);
    allPost.removeWhere((e) => e.id == id);
    // await getAllPost();
    notifyListeners();
  }

  Future<void> editAttendance(Attendance att) async {
    await ApiHelper.apiHelper.editAttendance(att);
    notifyListeners();
  }

  Future<void> addAttendance(Attendance att) async {
    await ApiHelper.apiHelper.addAttendance(att);
    notifyListeners();
  }

  addNotification(String text, String senderId, String receiverId) async {
    final now = new DateTime.now();
    String formatter = DateFormat('yMd').format(now);
    await ApiHelper.apiHelper.addnotification(Notifications(
        text: text,
        date: formatter,
        senderId: senderId,
        receiverId: receiverId,
        isClicked: false));
    // MainScreenNotifiers mai;
    // mai.getAllNotifications();
    notifyListeners();
  }

  File file;
  String name;
  PlatformFile platformFile;
  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      this.name = result.paths.first;
      this.platformFile = result.files.first;
      this.file = File(platformFile.path);
    }

    notifyListeners();
  }

  String convertDateToAr(String date) {
    List<String> month = [
      'يناير',
      'فبراير',
      'مارس',
      'ابريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    if (DateTime.tryParse(date) != null) {
      DateTime dateTime = DateTime.parse(date);
      return dateTime.day.toString() +
          " " +
          month[dateTime.month - 1] +
          " " +
          dateTime.year.toString();
    }
    try {
      List<String> partsOfDate = date.split('/'); // for example 5/2/2022

      return partsOfDate[0] +
          " " +
          month[int.parse(partsOfDate[1]) - 1] +
          " " +
          partsOfDate[2];
    } on Exception catch (_) {}
    return date;
  }

  Future<void> addHomework(
      String title, String description, String date, String teacherId) async {
    String imageUrl =
        await FirebaseStorageHelper.firebaseStorageHelper.uploadImage(file);
    Homework homework = Homework(
        title: title,
        description: description,
        endDate: date,
        fileUrl: imageUrl,
        teacherId: teacherId);
    await ApiHelper.apiHelper.addHomework(homework);
    allHomework.insert(0, homework);

    notifyListeners();
  }

  List<Homework> allHomework = [];
  Future<void> getAllHomework() async {
    allHomework = await ApiHelper.apiHelper
        .getAllhomework(await SPHelper.spHelper.getUId());
    notifyListeners();
  }

  Future<void> deleteHomework(String id) async {
    await ApiHelper.apiHelper.deleteAllSubmitterForThisHomework(id);
    await ApiHelper.apiHelper.deleteHomework(id);
    toast('تم حذف الواجب بنجاح', duration: Duration(milliseconds: 4000));
    allHomework.removeWhere((e) => e.id == id);

    notifyListeners();
  }

  Future<void> editHomework(Homework hw) async {
    String imageUrl;

    if (name != null) {
      imageUrl =
          await FirebaseStorageHelper.firebaseStorageHelper.uploadImage(file);
      hw.fileUrl = imageUrl;
    }
    await ApiHelper.apiHelper.editHomework(hw);
    toast('لحظات قليلة وينتهي التعديل');

    int index = allHomework.indexWhere((e) => e.id == hw.id);
    allHomework[index] = hw;

    toast('تم التعديل بنجاح', duration: Duration(milliseconds: 4000));
    notifyListeners();
  }

  Homework homework;
  getHomeworkDetalis(String id) async {
    Homework home = await ApiHelper.apiHelper.getHomeworkDetalis(id);
    homework = home;
    notifyListeners();
  }

  List<Submit> allSubmit;
  Future<void> getAllSumbmiters(String idHW) async {
    allSubmit = await ApiHelper.apiHelper.getAllSumbmiters(idHW) ?? [];
    notifyListeners();
  }

  Submit sub;
  getSubmitDetalis(String id) async {
    Submit _sub = await ApiHelper.apiHelper.getSubmitDetalisForTheHW(id);
    sub = _sub;
    notifyListeners();
  }

  Future<void> addMarkAndNote(String idSubmit, String mark, String note) async {
    await ApiHelper.apiHelper.addMarkAndNote(idSubmit, mark, note);
    notifyListeners();
  }

  students std;
  getStd(String stdId) async {
    std = await ApiHelper.apiHelper.getStd(stdId);
    notifyListeners();
  }

  Future<students> returnStdData(String stdId) async {
    return await ApiHelper.apiHelper.getStd(stdId);
  }
  // END logic methods for teacher user

// ||...................... logic methods ............................||

}
