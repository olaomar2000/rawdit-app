//||... Class for all constants inside the app ...||

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

GoogleMapController googleMapController;

class Constants {
// start : ||... APP_NAME ...||
  static const String APP_NAME = 'Rawdati';

// end : ||... APP_NAME ...||

// start : ||... Google Map Ke...||
  static const String GOOGLE_MAP_KEY =
      'AIzaSyBCMfjbP_2xy5TY5t6ILqNgFadSuBRDeEY';

  static final CameraPosition kGooglePosition = CameraPosition(
    target: LatLng(31.416665, 34.333332),
    zoom: 14.4746,
  );

//           ||-------------------------------------------||
// start : ||... SCREENS_NAMES ...||

  // SHARED SCREENS >>
  static const String SCREENS_SPLASH_SCREEN = 'SplashScreen';
  static const String SCREENS_USER_TYPE_SCREEN = 'UserTypeScreen';
  static const String SCREENS_ADS_SCREEN = 'AdsScreen';
  // STUDENT SCREENS >>
  static const String SCREENS_MAIN_SCREEN = 'MainScreen';
  static const String SCREENS_LOGIN_WITH_ID_SCREEN = 'LoginWithIdScreen';
  static const String SCREENS_LOGIN_WITH_QR_SCREEN = 'LoginWithQRScreen';
  static const String SCREENS_EDIT_HOMEWORK = 'EditHomework';
  static const String SCREENS_FULL_IMAGE = 'fullImage';
  static const String SCREENS_SHOW_VIDEO = 'showVideo';

  static const String SCREENS_ASIGNMENT_DETAILS_SCREEN =
      'AsignmentDetailsScreen';
  // TEACHER SCREENS >>

  static const String SCREENS_TEACHER_LOGIN_SCREEN = 'TeacherLoginWithIdScreen';
  static const String SCREENS_TEACHER_LOGIN_WITH_QR_SCREEN =
      'TeacherLoginWithQRScreen';
  static const String SCREENS_TEACHER__MAIN_SCREEN = 'TeacherMainScreen';
  static const String SCREENS_ADD_ASSIGNMENT_SCREEN = 'AddAssignmentScreen';
  static const String SCREENS_ASSIGNMENT_CONFIRM_SCREEN =
      'AssignmentConfirmScreen';
  static const String SCREENS_TEACHER_ASSIGNMENT_DETAILS_SCREEN =
      'TeacherAssignmentDetailsScreen';
  static const String SCREENS_ADD_POST_SCREEN = 'AddPostScreen';
  static const String SCREENS_POST_SCREEN = 'PostScreen';
  static const String SCREENS_ATTENDANCE_SCREEN = 'Attendance';
  static const String SCREENS_TEACHER_QR_SCREEN = 'QrScareen';

// end : ||... SCREENS_NAMES ...||

//           ||-------------------------------------------||

//           ||-------------------------------------------||

// start : ||... ASSETS ...||
  static const String ASSETS_IMAGES_PATH = 'assets/images/';

// end : ||... ASSETS ...||

//           ||-------------------------------------------||


//           ||-------------------------------------------||

// start : ||... URL ...||

  static const String TEACHER_URL =
      "https://first-app-391ee.firebaseio.com/teachers.json";
  static const String STUDENT_URL =
      "https://first-app-391ee.firebaseio.com/students.json";
  static const String SECTION_URL =
      "https://first-app-391ee.firebaseio.com/sections.json";
  static const String POST_URL =
      "https://first-app-391ee.firebaseio.com/posts.json";

  static const String Notifications_URL =
      "https://first-app-391ee.firebaseio.com/notifications.json";
  static const String HomeWork_URL =
      "https://first-app-391ee.firebaseio.com/homework.json";

  static const String Submit_URL =
      "https://first-app-391ee.firebaseio.com/submit.json";

  static const String Attendances_URL =
      "https://first-app-391ee.firebaseio.com/attendances.json";

  // end : ||... INTEGER VALUES ...||

//           ||-------------------------------------------||

  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
}
