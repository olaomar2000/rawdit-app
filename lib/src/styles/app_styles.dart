//||... Class for all shared styles inside the app  ...||
import 'package:flutter/material.dart';

class AppStyles {
  //|. default  padding .|
  static const EdgeInsets defaultPadding1 = const EdgeInsets.all(8);
  static const EdgeInsets defaultPadding2 = const EdgeInsets.all(12);
  static const EdgeInsets defaultPadding3 = const EdgeInsets.all(16);
  static const EdgeInsets defaultPadding4 = const EdgeInsets.all(24);
  static const EdgeInsets defaultPadding5 = const EdgeInsets.symmetric(vertical: 8,horizontal: 15);


  //|. default  border radius .|
  static const BorderRadius defaultBorderRadius = const BorderRadius.all(
    Radius.circular(16),
  );

  // text form field border radius
  static BorderRadius customRoundedBorderRadius() =>BorderRadius.circular(15);

      // AppShared.sharedPreferencesController.getAppLang() == Constants.LANG_AR
      //     ? BorderRadius.only(
      //         topRight: Radius.circular(15),
      //         bottomRight: Radius.circular(15),
      //       )
      //     : BorderRadius.only(
      //         topLeft: Radius.circular(15),
      //         bottomLeft: Radius.circular(15),
      //       );

  // default icon theme.
  static const IconThemeData defaultIconTheme =
      const IconThemeData(color: Colors.white);
}
