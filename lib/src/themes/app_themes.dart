import 'package:flutter/material.dart';

//\\... light theme ...||
ThemeData getLightTheme() => ThemeData(
      primarySwatch: const MaterialColor(0xff005FAD, {
        50: Color(0xff0D72B9),
        100: Color(0xff0D72B9),
        200: Color(0xff0D72B9),
        300: Color(0xff0D72B9),
        400: Color(0xff0D72B9),
        500: Color(0xff0D72B9),
        600: Color(0xff0D72B9),
        700: Color(0xff0D72B9),
        800: Color(0xff0D72B9),
        900: Color(0xff0D72B9),
      }),
      cursorColor: customBlue,
      accentColor: customBlue,
      buttonColor: customBlue,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: customBlue,
      ),
      backgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xff0D72B9),
      ),
      scaffoldBackgroundColor: const Color(0xffF8F8F8),
      bottomSheetTheme: BottomSheetThemeData(
          //   backgroundColor: AppShared.appTheme['background']
          ),
      primaryColor: const Color(0xff0D72B9),
      fontFamily: 'ArbFONTS-Almarai',
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
    );
const Color customBlue = Color(0xff005FAD);
const Color customGrey = Color(0xff707070);
const Color customRed = Color(0xffB82525);
const Color MainFontColor = Color.fromRGBO(112, 112, 112, 1);
const Color subFontColor = Color.fromRGBO(228, 228, 228, 1);
// 112
//228