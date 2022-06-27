import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../notifiers/teacher_main_screen_notifiers.dart';
import '../../../../utils/constants.dart';
import '../../../components/attendance_component.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({Key key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  TeacherMainScreenNotifiers provider = Provider.of<TeacherMainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);
  bool _loaded = false;
  List<Color> color = [
    Colors.black,
    Colors.blue,
    Colors.brown,
    Colors.green,
    Colors.yellow,
    Colors.pink,
    Colors.orange
  ];
  List<String> extractStudentsIdsFromAttendance = [];
  Future<void> getData() async {
    await provider.getAllSection();
    await provider.getStudentInSecation(provider.sec.id);
    await provider.allTodayAttendances.forEach((e) {
      extractStudentsIdsFromAttendance.add(e.stdId);
    });
    if (!mounted) return;
    setState(() {});
  }

  ScrollController _hideButtonController;
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
        title: Text('الحضور'),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: !_loaded
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'الطلاب',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  provider.studentInSecation == null
                      ? Container(
                          color: Colors.white,
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                            controller: _hideButtonController,
                            shrinkWrap: true,
                            itemCount: provider.studentInSecation.length,
                            itemBuilder: (context, index) =>
                                AttendanceComponent(
                              std: provider.studentInSecation[index],
                              // if the teacher takes the attendance using qr, the next line will show who is attended and not
                              val: extractStudentsIdsFromAttendance.indexOf(
                                          provider
                                              .studentInSecation[index].id) !=
                                      -1
                                  ? true
                                  : false,
                              color: color,
                              indexOfColor:
                                  (new Random()).nextInt(color.length),
                            ),
                            separatorBuilder:
                                (BuildContext context, int index) => SizedBox(
                              height: 10,
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}
