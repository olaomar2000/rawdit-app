import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreenBody();
  }
}

class SplashScreenBody extends StatefulWidget {
  @override
  _SplashScreenBodyState createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () async {
      if (await SPHelper.spHelper.getOnboarding() == true) {
        Navigator.pushNamedAndRemoveUntil(
            context, Constants.SCREENS_USER_TYPE_SCREEN, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, Constants.SCREENS_ADS_SCREEN, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(BoxConstraints(maxHeight: 812, maxWidth: 375),
        designSize: Size(414, 896));
    return Scaffold(
        //  backgroundColor: Theme.of(context).primaryColor,
        body: Center(
      child: SvgPicture.asset(
        '${Constants.ASSETS_IMAGES_PATH}loading.svg',
      ),
    ));
  }
}
