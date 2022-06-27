//||... File for app routes ...||

import 'package:arabi/src/view/screens/splash_screen.dart';
import 'package:arabi/src/view/screens/student/assignment_details.dart/assignment_details_screen.dart';
import 'package:arabi/src/view/screens/student/auth/login_with_id_screen.dart';
import 'package:arabi/src/view/screens/student/auth/login_with_qr.dart';
import 'package:arabi/src/view/screens/full_image_screen.dart';
import 'package:arabi/src/view/screens/student/main_screen/main_screen.dart';
import 'package:arabi/src/view/screens/show_video_screen.dart';
import 'package:arabi/src/view/screens/teacher/add_assignment_screen.dart';
import 'package:arabi/src/view/screens/teacher/assignment_confirm_screen.dart';
import 'package:arabi/src/view/screens/teacher/auth/teacher_login_screen.dart';
import 'package:arabi/src/view/screens/teacher/auth/teacher_login_with_qr.dart';
import 'package:arabi/src/view/screens/teacher/edit_homework_screen.dart';
import 'package:arabi/src/view/screens/teacher/main_screen/attendance_screen.dart';
import 'package:arabi/src/view/screens/teacher/main_screen/post_screen.dart';
import 'package:arabi/src/view/screens/teacher/main_screen/qr_screen.dart';
import 'package:arabi/src/view/screens/teacher/main_screen/teacher_main_screen.dart';
import 'package:arabi/src/view/screens/teacher/add_post_screen.dart';
import 'package:arabi/src/view/screens/teacher/teacher_assignment_details_screen.dart';
import 'package:arabi/src/view/screens/user_type_screen.dart';
import 'package:arabi/src/view/screens/ads_screen.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

Map<String, Widget Function(BuildContext context)> appRoutes = {
  // ||... SHARED SCREENS ...||
  Constants.SCREENS_SPLASH_SCREEN: (_) => SplashScreen(),
  Constants.SCREENS_USER_TYPE_SCREEN: (_) => UserTypeScreen(),
  Constants.SCREENS_ADS_SCREEN: (_) => AdsScreen(),

  // ||... STUDENTS SCREENS ...||
  Constants.SCREENS_LOGIN_WITH_ID_SCREEN: (_) => LoginWithIdScreen(),
  Constants.SCREENS_MAIN_SCREEN: (_) => MainScreen(),
  Constants.SCREENS_ASIGNMENT_DETAILS_SCREEN: (_) => AssignmentDetailsScreen(),

  // ||... TEACHER SCREENS ...||
  Constants.SCREENS_TEACHER_LOGIN_SCREEN: (_) => TeacherLoginScreen(),
  Constants.SCREENS_TEACHER__MAIN_SCREEN: (_) => TeacherMainScreen(),
  Constants.SCREENS_ADD_ASSIGNMENT_SCREEN: (_) => AddAssignmentScreen(),
  Constants.SCREENS_ASSIGNMENT_CONFIRM_SCREEN: (_) =>
      AssignmentConfirmScreen(null),
  Constants.SCREENS_TEACHER_ASSIGNMENT_DETAILS_SCREEN: (_) =>
      TeacherAssignmentDetailsScreen(),
  Constants.SCREENS_ADD_POST_SCREEN: (_) => AddPostScreen(),
  Constants.SCREENS_TEACHER_QR_SCREEN: (_) => QrScreen(),
  Constants.SCREENS_LOGIN_WITH_QR_SCREEN: (_) => LoginWithQRScreen(),
  Constants.SCREENS_TEACHER_LOGIN_WITH_QR_SCREEN: (_) =>
      TeacherLoginWithQRScreen(),
  Constants.SCREENS_EDIT_HOMEWORK: (_) =>
      EditHomework(null, null, null, null, null, null),
  Constants.SCREENS_FULL_IMAGE: (_) => FullImage(),
  Constants.SCREENS_SHOW_VIDEO: (_) => ShowVideoScreen(),
  Constants.SCREENS_POST_SCREEN: (_) => PostScreen(),
  Constants.SCREENS_ATTENDANCE_SCREEN: (_) => AttendanceScreen(),
};
