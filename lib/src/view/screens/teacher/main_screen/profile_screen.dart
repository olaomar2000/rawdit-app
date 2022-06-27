import 'package:arabi/src/data/api_helper.dart';
import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../notifiers/teacher_main_screen_notifiers.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TeacherMainScreenNotifiers provider = Provider.of<TeacherMainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);
  bool _loaded = false;

  Future<void> getData() async {
    await provider.getTeacherInfo();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (!_loaded) {
      getData().then((value) {
        _loaded = true;
        if (!mounted) return;
        setState(() {});
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('الملف الشخصي'),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              const Color(0xffA9C0E2),
              const Color(0xffFFFFFF),
              const Color(0xffFFFFFF),
            ])),
        child: !_loaded
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          CircleAvatar(
                            radius: 40,
                            child: Center(
                              child: Text(
                                provider.teacher.name[0] ?? "م",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            backgroundColor: Color(0xffB82525),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            provider.teacher.name ?? "yuru",
                            style: TextStyle(
                                color: customGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                          //  const SizedBox(height: 5,),
                          Text(
                            'معلمة',
                            style: TextStyle(
                                color: customBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    isLandscape ? Container() : const SizedBox(height: 170),
                    ProfileItem(
                      iconName: 'id',
                      title: provider.teacher.identificationNumber,
                    ),
                    // ProfileItem(
                    //   iconName: 'location',
                    //   title: 'العنوان',
                    // ),
                    ProfileItem(
                      iconName: 'power',
                      title: 'تسجيل الخروج',
                      onTap: () async {
                        await SPHelper.spHelper.deleteKey('u_id');
                        await SPHelper.spHelper.deleteKey('type');
                        await SPHelper.spHelper.deleteKey('remembered');
                        await ApiHelper.apiHelper
                            .removeNotificationId('teachers');
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Constants.SCREENS_USER_TYPE_SCREEN,
                            (route) => false);
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String iconName;
  final Widget tail;
  final Function onTap;
  const ProfileItem({
    Key key,
    this.title,
    this.iconName,
    this.tail,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: const BoxDecoration(
            border: const Border(
          bottom: const BorderSide(color: const Color(0xffEEEEEE)),
        )),
        child: Row(
          children: [
            SvgPicture.asset(
              '${Constants.ASSETS_IMAGES_PATH}$iconName.svg',
              width: 25,
              height: 25,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: customGrey, fontSize: 20),
              ),
            ),
            if (tail != null) tail
          ],
        ),
      ),
    );
  }
}
