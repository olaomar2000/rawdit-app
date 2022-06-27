import 'dart:async';

import 'package:arabi/src/models/student.dart';
import 'package:arabi/src/models/submit.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/view/components/custom_btn_component.dart';
import 'package:arabi/src/view/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/teacher_main_screen_notifiers.dart';
import '../../../utils/constants.dart';
import '../full_image_screen.dart';
import '../show_video_screen.dart';

class AssignmentConfirmScreen extends StatefulWidget {
  final Submit stdSubmit;
  AssignmentConfirmScreen(this.stdSubmit);
  @override
  _AssignmentConfirmScreenState createState() =>
      _AssignmentConfirmScreenState();
}

class _AssignmentConfirmScreenState extends State<AssignmentConfirmScreen> {
  students std;
  Submit teacherSubmit; // that's mean the teacher already filled the mark
  bool _send = false;
  TeacherMainScreenNotifiers _teacherMainScreenNotifiers =
      Provider.of<TeacherMainScreenNotifiers>(Constants.navKey.currentContext,
          listen: false);
  String _fileName = 'No name';
  @override
  void initState() {
    getStdData();

    super.initState();
  }

  bool _submittionIsExist = false;
  Future<void> showTheFile(String file) async {
    if (file != 'file') {
      if (file.contains(".mp4")) {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) =>
                ShowVideoScreen(src: file, tag: file),
          ),
        );
      } else {
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => FullImage(src: file, tag: file),
          ),
        );
      }
    }
  }

  Future<void> getStdData() async {
    std =
        await _teacherMainScreenNotifiers.returnStdData(widget.stdSubmit.stdId);
    if (!mounted) return;
    setState(() {});
    String file = widget.stdSubmit.file;

    if (file != 'file')
      _fileName = file
          .substring(0, file.indexOf('?'))
          .substring(file.lastIndexOf('/') + 1)
          .replaceAll('%2F', ' ');
    await _teacherMainScreenNotifiers
        .getAllSumbmiters(widget.stdSubmit.homeworkId);
    await _teacherMainScreenNotifiers.allSubmit.forEach((e) {
      if (e.homeworkId == widget.stdSubmit.homeworkId &&
          e.stdId == std.id &&
          e.mark != 'mark') {
        _submittionIsExist = true;
        teacherSubmit = e;
        // return;
      }
    });
    if (_submittionIsExist) {
      _MarkController.text = teacherSubmit.mark;
      _NoteController.text =
          teacherSubmit.note == 'note' ? '' : teacherSubmit.note;
    }
    if (teacherSubmit == null) teacherSubmit = Submit();
    if (!mounted) return;
    setState(() {});
    ;
  }

  final TextEditingController _MarkController = TextEditingController();
  final TextEditingController _NoteController = TextEditingController();

  @override
  void dispose() {
    _MarkController.dispose();
    _NoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الواجبات'),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: customBlue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          color: Colors.white,
        ),
      ),
      body: teacherSubmit == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            child: Text(
                              'م',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                            backgroundColor: Color(0xffB82525),
                          ),
                          title: Text(
                            // provider.homework.title,
                            std.name,
                            style:
                                TextStyle(color: MainFontColor, fontSize: 22),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    IconButton(
                      icon: Image.network(widget.stdSubmit.file),
                      onPressed: () async {
                        await showTheFile(widget.stdSubmit.file);
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          '${Constants.ASSETS_IMAGES_PATH}photo.svg',
                          color: Theme.of(context).primaryColor,
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Text(
                            _fileName,
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomTextField('العلامة',
                        textEditingController: _MarkController),
                    CustomTextField('ملاحظات',
                        textEditingController: _NoteController),
                    _send
                        ? CircularProgressIndicator()
                        : CustomBtnComponent(
                            color: customBlue,
                            height: 50,
                            text: _submittionIsExist ? 'تعديل' : 'ارسال',
                            onTap: () async {
                              if (_MarkController.text.trim() == '') {
                                toast('يجب عليك وضع علامة للارسال');
                                return;
                              }
                              _send = true;
                              setState(() {});
                              await _teacherMainScreenNotifiers.addMarkAndNote(
                                  widget.stdSubmit.id,
                                  _MarkController.text,
                                  _NoteController.text);
                              await _teacherMainScreenNotifiers
                                  .sendNotificatonStudent(
                                      widget.stdSubmit.stdId,
                                      "اشعار جديد",
                                      "تم رصد علامة للواجب البيتي");
                              _send = false;
                              if (!mounted) return;
                              setState(() {});
                              Timer timer =
                                  Timer(Duration(milliseconds: 3000), () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              });
                              showDialog(
                                context: context,
                                barrierColor: customBlue.withOpacity(0.13),
                                builder: (BuildContext context) {
                                  
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    content: Container(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          SvgPicture.asset(
                                            '${Constants.ASSETS_IMAGES_PATH}blue-check-mark.svg',
                                            width: 50,
                                            height: 50,
                                          ),
                                          const SizedBox(height: 30),
                                          const Text(
                                            'تم ارسال العلامة',
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff707070)),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ).then(
                                (value) {
                                  timer.cancel();
                                  timer = null;
                                },
                              );
                            },
                          )
                  ],
                ),
              ),
            ),
    );
  }
}
