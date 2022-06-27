import 'package:arabi/src/data/api_helper.dart';
import 'package:arabi/src/notifiers/teacher_main_screen_notifiers.dart';
import 'package:arabi/src/view/screens/teacher/main_screen/assigenments_screen.dart';
import 'package:arabi/src/view/screens/teacher/main_screen/attendance_screen.dart';
import 'package:arabi/src/view/screens/teacher/main_screen/post_screen.dart';
import 'package:arabi/src/view/screens/teacher/main_screen/profile_screen.dart';
import 'package:arabi/src/view/screens/teacher/main_screen/qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../utils/constants.dart';

class TeacherMainScreen extends StatefulWidget {
  @override
  State<TeacherMainScreen> createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeacherMainScreen>
    with SingleTickerProviderStateMixin {
  TeacherMainScreenNotifiers provider = Provider.of<TeacherMainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);

  final PageController _pageController = PageController(initialPage: 0);
  int _index = 0;
  @override
  void dispose() {
    _pageController.dispose();
    _scrollBottomBarController.removeListener(() {
      _scrollBottomBarController.dispose();
    });
    super.dispose();
  }

  ScrollController _scrollBottomBarController;
  bool isScrollingDown = false;

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          provider.hideBottomBar();
          setState(() {});
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          provider.showBottomBar();
          setState(() {});
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initalGetData();
    _scrollBottomBarController = provider.scrollBottomBarController;
    myScroll();
  }

  Future<void> initalGetData() async {
    await ApiHelper.apiHelper.updateNotificationId("teachers");
    await provider.getAllSection();
  }

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  bool _isDoubleClickToExit = false;

  Future<bool> _onWillPop() async {
    _scaffoldState.currentState.hideCurrentSnackBar();
    if (!_isDoubleClickToExit) {
      _scaffoldState.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'الخروج من التطبيق؟',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      _isDoubleClickToExit = true;
      return false;
    } else {
      // exit(0);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldState,
        bottomNavigationBar: AnimatedContainer(
          height: !provider.hide ? 0.0 : 70,
          duration: Duration(milliseconds: 1000),
          child: Card(
            elevation: 20,
            margin: EdgeInsets.zero,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              )),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              height: 70,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _index = 0;
                              setState(() {});
                              _pageController.jumpToPage(0);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                '${Constants.ASSETS_IMAGES_PATH}megaphone.svg',
                                width: 27,
                                height: 27,
                                color: _index == 0
                                    ? Theme.of(context).primaryColor
                                    : const Color.fromARGB(255, 134, 134, 134),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _index = 1;
                              setState(() {});
                              _pageController.jumpToPage(1);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                '${Constants.ASSETS_IMAGES_PATH}assignmen.svg',
                                color: _index == 1
                                    ? Theme.of(context).primaryColor
                                    : const Color.fromARGB(255, 134, 134, 134),
                                width: 27,
                                height: 27,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 3, child: Container()),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _index = 3;
                              setState(() {});
                              _pageController.jumpToPage(3);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                '${Constants.ASSETS_IMAGES_PATH}calendar.svg',
                                color: _index == 3
                                    ? Theme.of(context).primaryColor
                                    : const Color.fromARGB(255, 134, 134, 134),
                                width: 27,
                                height: 27,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _index = 4;
                              setState(() {});
                              _pageController.jumpToPage(4);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                '${Constants.ASSETS_IMAGES_PATH}profile_nav.svg',
                                width: 27,
                                height: 27,
                                color: _index == 4
                                    ? Theme.of(context).primaryColor
                                    : const Color.fromARGB(255, 134, 134, 134),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            PostScreen(),
            AssignmentsScreen(),
            QrScreen(),
            AttendanceScreen(),
            ProfileScreen(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: AnimatedContainer(
          height: !provider.hide ? 0.0 : 70,
          duration: Duration(milliseconds: 1000),
          child: InkWell(
            onTap: () {
              _index = 2;
              _pageController.jumpToPage(2);

              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white, boxShadow: []),
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  '${Constants.ASSETS_IMAGES_PATH}qr-nav.svg',
                  width: 27,
                  height: 27,
                  color: _index == 2
                      ? Theme.of(context).primaryColor
                      : const Color.fromARGB(255, 134, 134, 134),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
