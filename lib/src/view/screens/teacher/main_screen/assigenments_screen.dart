import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../../../notifiers/teacher_main_screen_notifiers.dart';
import '../edit_homework_screen.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({Key key}) : super(key: key);

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  TeacherMainScreenNotifiers provider = Provider.of<TeacherMainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);

  bool _loaded = false;
  Future<void> getData() async {
    await provider.getAllHomework();
    if (!mounted) return;
    setState(() {});
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
        title: Text('التسليمات'),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: customBlue,
      ),
      body: !_loaded
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              'الواجبات',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            provider.file = null;
                            Navigator.of(context)
                                .pushNamed(
                                    Constants.SCREENS_ADD_ASSIGNMENT_SCREEN)
                                .then((_) => setState(() {}));
                          },
                          icon: Icon(
                            Icons.create_new_folder,
                            color: customBlue,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                    ...(provider.allHomework ?? []).map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Dismissible(
                          key: ValueKey(e.id),
                          background: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.grey[700],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(width: 15),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'تعديل',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          secondaryBackground: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.red,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'حذف',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                const SizedBox(width: 15),
                              ],
                            ),
                          ),
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.endToStart) {
                              showDialog<void>(
                                context: Constants.navKey.currentContext,
                                barrierDismissible:
                                    false, // user must tap button!
                                builder: (BuildContext context) {
                                  bool clicked = false;
                                  return AlertDialog(
                                    title: SvgPicture.asset(
                                      '${Constants.ASSETS_IMAGES_PATH}Polygon.svg',
                                      width: 50,
                                      height: 50,
                                    ),
                                    content:
                                        Text('هل أنت متأكد من حذف الواجب؟'),
                                    actions: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(customBlue),
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
                                                  MaterialStateProperty.all<
                                                      Color>(customBlue),
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

                                                toast(
                                                    "انتظر قليلاً حتى يتم الحذف بنجاح ...");
                                                await provider
                                                    .deleteHomework(e.id);
                                                await Navigator.of(context)
                                                    .pop();
                                                setState(() {});
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );

                              return false;
                            } else {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          EditHomework(
                                              e.id,
                                              e.title,
                                              e.description,
                                              e.endDate,
                                              e.fileUrl,
                                              e.teacherId),
                                    ),
                                  )
                                  .then((_) => setState(() {}));
                            }
                            return false;
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: ListTile(
                                onTap: () async {
                                  await provider.getHomeworkDetalis(e.id);
                                  await provider.getAllSumbmiters(e.id);
                                  provider.name = null;
                                  provider.file = null;
                                  provider.platformFile = null;
                                  Navigator.of(context)
                                      .pushNamed(Constants
                                          .SCREENS_TEACHER_ASSIGNMENT_DETAILS_SCREEN)
                                      .then((_) => setState(() {}));
                                },
                                leading: CircleAvatar(
                                  radius: 25,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SvgPicture.asset(
                                      '${Constants.ASSETS_IMAGES_PATH}assignment-nav.svg',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  'تاريخ الانتهاء :${provider.convertDateToAr(e.endDate)}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 141, 141, 141),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                title: Text(
                                  '${e.title}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        color: Color.fromRGBO(112, 112, 112, 1),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
