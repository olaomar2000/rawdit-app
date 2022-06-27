import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../../../notifiers/teacher_main_screen_notifiers.dart';
import '../../../../themes/app_themes.dart';
import '../../../../utils/constants.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TeacherMainScreenNotifiers provider = Provider.of<TeacherMainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);
  ScrollController _hideButtonController;

  bool _loaded = false;
  Future<void> getData() async {
    await provider.getAllPost();
    await provider.getTeacherInfo();

    if (!mounted) return;
    setState(() {});
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
          title: Text('الاعلانات'),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: customBlue,
        ),
        floatingActionButton: AnimatedContainer(
          height: provider.hide ? 0 : 50,
          duration: Duration(milliseconds: 1000),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
            color: customBlue,
          ),
          child: IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(Constants.SCREENS_ADD_POST_SCREEN)
                    .then((_) => setState(() {}));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              )),
        ),
        body: !_loaded
            ? Center(child: CircularProgressIndicator())
            : Consumer<TeacherMainScreenNotifiers>(
                builder: (context, provider, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: AnimatedContainer(
                            height: !provider.hide
                                ? 0
                                : MediaQuery.of(context).size.height * .15,
                            curve: Curves.fastOutSlowIn,
                            duration: Duration(milliseconds: 2000),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(
                                        Constants.SCREENS_ADD_POST_SCREEN)
                                    .then((_) => setState(() {}));
                              },
                              title: Text(
                                'بماذا تفكر ؟',
                                style: TextStyle(
                                    color: Color(0xff707070),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: customRed,
                                radius: 25,
                                child: Text(
                                  provider.teacher.name[0],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            controller: _hideButtonController,
                            shrinkWrap: true,
                            itemCount: provider.allPost.length,
                            // physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: customRed,
                                            radius: 25,
                                            child: Text(
                                              provider.teacher.name[0],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                provider.teacher.name,
                                                style: TextStyle(
                                                    color: Color(0xff707070),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    provider.convertDateToAr(
                                                        provider.allPost[index]
                                                            .date),
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffE4E4E4),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17),
                                                  ),
                                                  PopupMenuButton(
                                                    icon:
                                                        Icon(Icons.more_horiz),
                                                    itemBuilder: (context) {
                                                      return <PopupMenuEntry>[
                                                        PopupMenuItem(
                                                          value: 'حذف',
                                                          child: Container(
                                                            width: 80,
                                                            child:
                                                                TextButton.icon(
                                                                    label: Text(
                                                                      'حذف',
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              155,
                                                                              155,
                                                                              155),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      await showDialog<
                                                                          void>(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          bool
                                                                              cliked =
                                                                              false;
                                                                          return AlertDialog(
                                                                            title:
                                                                                SvgPicture.asset(
                                                                              '${Constants.ASSETS_IMAGES_PATH}Polygon.svg',
                                                                              width: 50,
                                                                              height: 50,
                                                                            ),
                                                                            content:
                                                                                Text('هل أنت متأكد من حذف هذا الاعلان؟'),
                                                                            actions: <Widget>[
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  ElevatedButton(
                                                                                    style: ButtonStyle(
                                                                                      backgroundColor: MaterialStateProperty.all<Color>(customBlue),
                                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: customBlue))),
                                                                                    ),
                                                                                    child: const Text('لا'),
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                  ),
                                                                                  ElevatedButton(
                                                                                    style: ButtonStyle(
                                                                                      backgroundColor: MaterialStateProperty.all<Color>(customBlue),
                                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: customBlue))),
                                                                                    ),
                                                                                    child: const Text('نعم'),
                                                                                    onPressed: () async {
                                                                                      toast("انتظر قليلاً حتى يتم الحذف بنجاح ...");

                                                                                      if (!cliked) {
                                                                                        cliked = true;

                                                                                        await provider.deletePost(provider.allPost[index].id);

                                                                                        toast('تم حذف الاعلان بنجاح ', duration: Duration(milliseconds: 90));
                                                                                        // await getData();
                                                                                        provider.hide = true;
                                                                                        if (!mounted) return;
                                                                                        setState(() {});
                                                                                        Navigator.of(context).pop();
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
                                                                    icon: Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .red,
                                                                    )),
                                                          ),
                                                        )
                                                      ];
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                      Text(
                                        provider.allPost[index].content,
                                        style:
                                            TextStyle(color: Color(0xff707070)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            separatorBuilder:
                                (BuildContext context, int index) => SizedBox(
                              height: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ));
  }
}
