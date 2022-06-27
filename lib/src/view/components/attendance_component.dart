import 'package:arabi/src/data/api_helper.dart';
import 'package:arabi/src/models/attendance.dart';
import 'package:arabi/src/models/student.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../notifiers/teacher_main_screen_notifiers.dart';
import '../../utils/constants.dart';

class AttendanceComponent extends StatefulWidget {
  final students std;
  bool val;
  final List<Color> color;
  final int indexOfColor;
  AttendanceComponent({
    Key key,
    this.std,
    this.val = false,
    this.color,
    this.indexOfColor,
  }) : super(key: key);

  @override
  State<AttendanceComponent> createState() => _AttendanceComponentState();
}

class _AttendanceComponentState extends State<AttendanceComponent> {
  String _date = DateTime.now().year.toString() +
      "/" +
      DateTime.now().month.toString() +
      "/" +
      DateTime.now().day.toString();

  bool alreadyAttend = false;
  bool _loaded = false;
  String id = '';

  TeacherMainScreenNotifiers provider = Provider.of<TeacherMainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);

  Future<void> getData() async {
    await provider.getAllTodayAttendances();
    provider.allTodayAttendances.forEach((e) {
      // seach in all attendance to get the id
      if (e.stdId == widget.std.id && e.date == _date) {
        id = e.id;
        alreadyAttend = true;
        if (!mounted) return;
        setState(() {});
        return;
      }
    });
  }

  Future<void> onClicked({bool value}) async {
    if (value != null) {
      widget.val = value;
    } else {
      widget.val = !widget.val;
    }

    if (widget.val && !alreadyAttend) {
      Attendance attendance =
          Attendance(date: _date, singout: false, stdId: widget.std.id);
      if (provider.allTodayAttendances.indexOf(attendance) == -1) {
        toast('تم تسجيل ${widget.std.name} بأنه حاضر');
        await ApiHelper.apiHelper.addAttendance(attendance);
      }
    } else {
      // if the teacher removed the check mark, delete the std from the table

      if (id != '') {
        toast('تم احتساب ${widget.std.name} بأنه غائب');
        await ApiHelper.apiHelper.deleteAttendance(id);

        alreadyAttend = false;
        widget.val = false;
        if (!mounted) return;
        setState(() {});
      }
    }
    await getData();
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
    return InkWell(
      onTap: () async => await onClicked(),
      child: !_loaded
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    child: Text(
                      widget.std.name[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    backgroundColor: widget.color[widget.indexOfColor],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      widget.std.name,
                      style: TextStyle(
                          color: Color(0xff707070),
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                  Checkbox(
                    value: widget.val || alreadyAttend,
                    onChanged: (value) async => await onClicked(value: value),
                  ),
                ],
              ),
            ),
    );
  }
}
