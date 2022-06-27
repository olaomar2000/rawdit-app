import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
// import 'package:flutter/services.dart' show rootBundle;

import 'package:arabi/src/data/api_helper.dart';
import 'package:arabi/src/models/attendance.dart';
// import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/models/homework.dart';
import 'package:arabi/src/models/notification.dart';
import 'package:arabi/src/models/post.dart';
import 'package:arabi/src/models/section.dart';
import 'package:arabi/src/models/student.dart';
import 'package:arabi/src/models/submit.dart';
import 'package:arabi/src/models/teacher.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:overlay_support/overlay_support.dart';

import '../data/firestorage_helper.dart';
import '../view/screens/full_image_screen.dart';
import '../view/screens/show_video_screen.dart';

class MainScreenNotifiers with ChangeNotifier {
  // ||....................... notifiable ..................................||
  bool isHomeScreen = true;
  bool navigateFromCategory = false;

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

  // START logic methods for student user

  students student;
  Future<void> getLoginStudentInfo() async {
    student = await ApiHelper.apiHelper.getLoginStudent();
    notifyListeners();
  }

  sections section;
  Future<void> getSectionInfoById() async {
    section = await ApiHelper.apiHelper.getSectionInfoById();
    notifyListeners();
  }

  List<Post> allPostStudent = [];
  getAllPost() async {
    allPostStudent = await ApiHelper.apiHelper.getAllPostInStudent();
    notifyListeners();
  }

  List<Homework> allHomeworkStudent = [];
  Future<void> getAllHomeworkStudent() async {
    allHomeworkStudent =
        await ApiHelper.apiHelper.getAllhomework(section.teacherId);
    notifyListeners();
  }

  Map<String, List<Homework>> submittedAndUnSubmittedHW = {};
  Future<void> getUnSubmittedHW() async {
    // should getAllHomeworkStudent() calls before this method to get all the hw and to can categories them
    submittedAndUnSubmittedHW = await ApiHelper.apiHelper
        .getSubmittedAndUnSubmittedhomework(allHomeworkStudent);
    if (submittedAndUnSubmittedHW.isEmpty) {
      submittedAndUnSubmittedHW = {
        "submittedIdsHw": [],
        "unSubmittedHwIds": allHomeworkStudent,
        "missedHandingHwIds": [],
      };
    }
    notifyListeners();
  }

  Future<void> deleteSubmit(String idSubmit) async {
    await ApiHelper.apiHelper.deleteSubmit(idSubmit);
    submittedAndUnSubmittedHW['submittedIdsHw']
        .removeWhere((e) => e.id == idSubmit);

    notifyListeners();
  }

  Homework homeworkStudent;
  getHomeworkDetalis(String id) async {
    homeworkStudent = await ApiHelper.apiHelper.getHomeworkDetalis(id);
    notifyListeners();
  }

  teachers teacher;
  Future<void> getTeacherInfo() async {
    teacher = await ApiHelper.apiHelper.getTeacherInfo();
    notifyListeners();
  }

  List<Notifications> allNotification = [];
  getAllNotifications(String id) async {
    allNotification = await ApiHelper.apiHelper.getAllNotifications(id);
    notifyListeners();
  }

  deleteNotifications(String id) async {
    await ApiHelper.apiHelper.deleteNotification(id);
    allNotification.removeWhere((e) => e.id == id);

    notifyListeners();
  }

  Future<List<Submit>> getAllSumbmiters(String idHW) async {
    return await ApiHelper.apiHelper.getAllSumbmiters(idHW);
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

  String readyTheUploadedImg = "";
  Future<void> uploadFile() async {
    readyTheUploadedImg =
        await FirebaseStorageHelper.firebaseStorageHelper.uploadImage(file);
  }

  Future<void> addSubmitAfterUploadTheImg(
      String stdId, String mark, String note, String homeworkId) async {
    await ApiHelper.apiHelper.addSubmit(Submit(
        stdId: stdId,
        mark: mark,
        note: note,
        file: readyTheUploadedImg,
        homeworkId: homeworkId));

    notifyListeners();
  }

  Future<Submit> getSubmitDetailForTheCurrentHW(String idHw) async {
    return await ApiHelper.apiHelper.getSubmitDetalisForTheHW(idHw);
  }

  Future<List<students>> getAllStds() async {
    return await ApiHelper.apiHelper.getAllStudents();
  }

  Future<teachers> getTeacherInBus() async {
    return await ApiHelper.apiHelper.getTeacherInBus();
  }

  Future<void> updateTeacherInBus(String idTeah, bool inBus) async {
    await ApiHelper.apiHelper.updateInBus(idTeah, inBus);
  }

  Future<void> sendNotidication(
      String studentId, String title, String body) async {
    await ApiHelper.apiHelper.sendNotificatonStudent(studentId, title, body);
  }

  Future<bool> isStdsStillExist() async {
    List<Attendance> todayAttendance =
        await ApiHelper.apiHelper.getAllTodayAttendances();
    bool exist = false;
    todayAttendance.forEach((e) {
      if (!e.singout) {
        exist = true;
        return;
      }
    });
    return exist;
  }
}
