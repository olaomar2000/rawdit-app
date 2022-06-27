
import 'package:arabi/src/notifiers/main_screen_notifiers.dart';
import 'package:arabi/src/notifiers/teacher_main_screen_notifiers.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:arabi/src/utils/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('ar', 'SA')],
      // supportedLocales: const [Locale('en', 'Us')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar', 'SA'),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<MainScreenNotifiers>(
            create: (_) => MainScreenNotifiers(),
          ),
          ChangeNotifierProvider<TeacherMainScreenNotifiers>(
            create: (_) => TeacherMainScreenNotifiers(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: getLightTheme(),
          navigatorKey: Constants.navKey,
          routes: appRoutes,
          title: 'Rawdati App',
          initialRoute: Constants.SCREENS_SPLASH_SCREEN,
        ),
      ),
    );
  }
}
