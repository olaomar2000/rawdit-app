import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:arabi/src/view/components/custom_btn_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            const Color(0xffE2E2E2),
            const Color(0xffA9C0E2),
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            SvgPicture.asset(
              '${Constants.ASSETS_IMAGES_PATH}logo.svg',
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            const SizedBox(
              height: 40,
            ),
            const Center(
              child: Text(
                'مرحبا بكم بيننا',
                //  AppShared.adsResponse.ads[index].title,
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.bold,
                  color: customBlue,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'قم بتسجيل الدخول بالبيانات التي أدخلتها  أثناء التسجيل في روضتك الخاصة',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: customBlue,
                ),
              ),
            ),
            const SizedBox(
              height: 61,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  height: MediaQuery.of(context).size.width * .1,
                  child: CustomBtnComponent(
                    onTap: () async {
                      if (await SPHelper.spHelper.getKey('remembered') ==
                              'true' &&
                          await SPHelper.spHelper.getKey('type') == 'std' &&
                          await SPHelper.spHelper.getUId() != null) {
                        Navigator.of(context).pushReplacementNamed(
                            Constants.SCREENS_MAIN_SCREEN);
                      } else
                        Navigator.of(context)
                            .pushNamed(Constants.SCREENS_LOGIN_WITH_ID_SCREEN);
                    },
                    text: 'الطالب',
                    color: Colors.white,
                    textColor: customBlue,
                    borderColor: Colors.white,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  height: MediaQuery.of(context).size.width * .1,
                  child: CustomBtnComponent(
                    onTap: () async {
                      if (await SPHelper.spHelper.getKey('remembered') ==
                              'true' &&
                          await SPHelper.spHelper.getKey('type') == 'teacher' &&
                          await SPHelper.spHelper.getUId() != null) {
                        Navigator.of(context).pushReplacementNamed(
                            Constants.SCREENS_TEACHER__MAIN_SCREEN);
                      } else
                        Navigator.of(context)
                            .pushNamed(Constants.SCREENS_TEACHER_LOGIN_SCREEN);
                    },
                    text: 'المعلم',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
