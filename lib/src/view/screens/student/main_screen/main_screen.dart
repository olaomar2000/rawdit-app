// import 'dart:io';
import 'package:arabi/src/data/api_helper.dart';
// import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/notifiers/main_screen_notifiers.dart';
import 'package:arabi/src/view/components/icon.dart';
import 'package:arabi/src/view/screens/student/main_screen/advertisement_screen.dart';
import 'package:arabi/src/view/screens/student/main_screen/assigenments_screen.dart';
import 'package:arabi/src/view/screens/student/main_screen/map_screen.dart';
import 'package:arabi/src/view/screens/student/main_screen/notifications_screen.dart';
import 'package:arabi/src/view/screens/student/main_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../../utils/constants.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScreenBody();
  }
}

class MainScreenBody extends StatefulWidget {
  @override
  _MainScreenBodyState createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<MainScreenBody>
    with SingleTickerProviderStateMixin {
  MainScreenNotifiers provider = Provider.of<MainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);
  bool _loading = true;
  int index = 4;
  PageController _controller = PageController(initialPage: 4);

  ScrollController _scrollBottomBarController;
  bool isScrollingDown = false;

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          provider.hideBottomBar();
          if (!mounted) return;
          setState(() {});
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          provider.showBottomBar();
          if (!mounted) return;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {
      _scrollBottomBarController.dispose();
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollBottomBarController = provider.scrollBottomBarController;
    myScroll();

    initalState();
  }

  Future<void> initalState() async {
    await ApiHelper.apiHelper.updateNotificationId("students");
    await provider.getSectionInfoById();

    await provider.getTeacherInBus();

    _loading = false;
    if (!mounted) return;
    setState(() {});
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
      child: _loading
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              resizeToAvoidBottomInset: false,
              key: _scaffoldState,
              bottomNavigationBar: AnimatedContainer(
                height: !provider.hide ? 0 : 70,
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 2000),
                child: Card(
                  elevation: 20,
                  margin: EdgeInsets.zero,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    )),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    index = 4;
                                    setState(() {});
                                    _controller.jumpToPage(index);
                                  },
                                  icon: Icon(
                                    CustomIcons.megaphone,
                                    size: 30,
                                    color: index == 4
                                        ? Theme.of(context).primaryColor
                                        : Color.fromARGB(255, 134, 134, 134),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    index = 3;
                                    setState(() {});
                                    _controller.jumpToPage(index);
                                  },
                                  icon: Icon(
                                    CustomIcons.assignment_nav,
                                    size: 30,
                                    color: index == 3
                                        ? Theme.of(context).primaryColor
                                        : Color.fromARGB(255, 134, 134, 134),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    index = 1;
                                    setState(() {});
                                    _controller.jumpToPage(index);
                                  },
                                  icon: Icon(
                                    CustomIcons.notifications_nav,
                                    color: index == 1
                                        ? Theme.of(context).primaryColor
                                        : Color.fromARGB(255, 134, 134, 134),
                                    size: 30,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    index = 0;
                                    _controller.jumpToPage(index);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    CustomIcons.profile_nav,
                                    size: 30,
                                    color: index == 0
                                        ? Theme.of(context).primaryColor
                                        : Color.fromARGB(255, 134, 134, 134),
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
              body: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child: PageView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    ProfileScreen(),
                    NotificationsScreen(),
                    MapScreen(),
                    AssignmentsScreen(),
                    AdvertisementScreen(),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniCenterDocked,
              floatingActionButton: AnimatedContainer(
                height: !provider.hide ? 0.0 : 70,
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 2000),
                child: InkWell(
                  onTap: () {
                    index = 2;
                    _controller.jumpToPage(2);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: []),
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        CustomIcons.location,
                        size: 35,
                        color: index == 2
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
