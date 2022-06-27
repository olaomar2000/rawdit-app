// import 'dart:math';

import 'package:arabi/src/notifiers/main_screen_notifiers.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  MainScreenNotifiers provider = Provider.of<MainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);
  ScrollController _hideButtonController;
  bool _loaded = false;
  Future<void> getData() async {
    await provider.getAllNotifications(provider.section.id);
  }

  @override
  void dispose() {
    _hideButtonController.removeListener(() {
      provider.hideBottomBar();
    });
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    _hideButtonController = provider.scrollBottomBarController;
    provider.myScroll();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      getData().then((value) {
        _loaded = true;
        if (!mounted) return;
        setState(() {});
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('الاشعارات'),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: !_loaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<MainScreenNotifiers>(builder: (context, provider, child) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: ListView.builder(
                  controller: _hideButtonController,
                  itemCount: provider.allNotification.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () async {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              bool clicked = false;
                              return AlertDialog(
                                title: SvgPicture.asset(
                                  '${Constants.ASSETS_IMAGES_PATH}Polygon.svg',
                                  width: 50,
                                  height: 50,
                                ),
                                content: Text(
                                    'هل أنت متأكد من أنك تريد حذف هذا الاشعار؟'),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  customBlue),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: customBlue))),
                                        ),
                                        child: const Text('لا'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  customBlue),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: customBlue))),
                                        ),
                                        child: const Text('نعم'),
                                        onPressed: () async {
                                          if (!clicked) {
                                            clicked = true;

                                            await provider.deleteNotifications(
                                                provider
                                                    .allNotification[index].id);

                                            toast('تم حذف الاشعار بنجاح');
                                            
                                            provider.hide = true;
                                            if (!mounted) return;
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: Color(0xffB82525),
                          child: Center(
                            child: Text(
                              provider.allNotification[index].text[0],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          provider.allNotification[index].text,
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontWeight: FontWeight.bold,
                              fontSize: 19),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
    );
  }
}
