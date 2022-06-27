import 'package:arabi/src/data/api_helper.dart';
import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/notifiers/main_screen_notifiers.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MainScreenNotifiers _mainScreenNotifiers = Provider.of<MainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);
  bool _loaded = false;

  Future<void> getData() async {
    await _mainScreenNotifiers.getLoginStudentInfo();
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
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color(0xffA9C0E2),
              Color(0xffFFFFFF),
              Color(0xffFFFFFF),
            ])),
        child: _mainScreenNotifiers.student == null ||
                _mainScreenNotifiers.section == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: Center(
                              child: Text(
                                _mainScreenNotifiers.student.name[0],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            backgroundColor: Color(0xffB82525),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            _mainScreenNotifiers.student.name,
                            style: TextStyle(
                                color: customGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 23),
                          ),
                          Text(
                            'صف ' +
                                _mainScreenNotifiers.section.category +
                                ' ' +
                                _mainScreenNotifiers.section.name,
                            style: TextStyle(color: customBlue, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    isLandscape
                        ? Container()
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * .1),
                    ProfileItem(
                      iconName: 'id',
                      title: _mainScreenNotifiers.student.identificationNumber,
                    ),
                    ProfileItem(
                      iconName: 'power',
                      title: 'تسجيل الخروج',
                      onTap: () async {
                        await SPHelper.spHelper.deleteKey('u_id');
                        await SPHelper.spHelper.deleteKey('type');
                        await SPHelper.spHelper.deleteKey('remembered');
                        await ApiHelper.apiHelper
                            .removeNotificationId('students');
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
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Color(0xffEEEEEE)),
        )),
        child: Row(
          children: [
            SvgPicture.asset(
              '${Constants.ASSETS_IMAGES_PATH}$iconName.svg',
              width: 25,
              height: 25,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: customGrey, fontSize: 20),
              ),
            ),
            if (tail != null) tail
          ],
        ),
      ),
    );
  }
}
