import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:arabi/src/view/components/custom_btn_component.dart';
import 'package:arabi/src/view/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/teacher_main_screen_notifiers.dart';

class AddAssignmentScreen extends StatefulWidget {
  const AddAssignmentScreen({Key key}) : super(key: key);

  @override
  _AddAssignmentScreenState createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _destextEditingController = TextEditingController();
  TextEditingController _marktextEditingController = TextEditingController();
  DateTime date;
  DateTime selectedDate = DateTime.now();
  bool _loaded = false;
  @override
  void dispose() {
    _titletextEditingController.dispose();
    _destextEditingController.dispose();
    _marktextEditingController.dispose();
    super.dispose();
  }

  TeacherMainScreenNotifiers provider = Provider.of<TeacherMainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text('انشاء واجب'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Consumer<TeacherMainScreenNotifiers>(
          builder: (_, provider, x) {
            return ListView(
              children: [
                CustomTextField('الاسم :',
                    textEditingController: _titletextEditingController),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField('الوصف :',
                    textEditingController: _destextEditingController),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField('العلامة :',
                    textEditingController: _marktextEditingController),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'الملفات المرفقة',
                        style:
                            TextStyle(color: Color(0xff707070), fontSize: 20),
                      ),
                    ),
                    TextButton.icon(
                      label: SvgPicture.asset(
                        '${Constants.ASSETS_IMAGES_PATH}attachment.svg',
                        width: 19,
                        height: 19,
                      ),
                      onPressed: () async {
                        _loaded = true;
                        setState(() {});
                        await provider.selectFile();
                        _loaded = false;
                        setState(() {});
                      },
                      icon: provider.file == null
                          ? Container()
                          : Text(
                              provider.getTheNameOfTheFile(
                                  provider.name, isLandscape),
                              style: TextStyle(color: customBlue),
                            ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: const Text(
                        'موعد التسليم',
                        style:
                            TextStyle(color: Color(0xff707070), fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "${provider.convertDateToAr(selectedDate.toIso8601String())}",
                        style: TextStyle(
                            color: customBlue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await _selectDate(context);
                      },
                      icon: SvgPicture.asset(
                        '${Constants.ASSETS_IMAGES_PATH}calender.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .2,
                ),
                _loaded
                    ? Center(
                        child: CircularProgressIndicator(
                        color: customBlue,
                      ))
                    : CustomBtnComponent(
                        height: 50,
                        text: 'انشاء',
                        onTap: () async {
                          if (_destextEditingController.text.trim() == "" ||
                              _titletextEditingController.text.trim() == "" ||
                              _marktextEditingController.text.trim() == "") {
                            toast(
                                'يجب عليك اضافة عنوان ووصف وعلامة لهذا الواجب');
                            return;
                          }
                          _loaded = true;
                          setState(() {});

                          await provider.addHomework(
                              _titletextEditingController.text,
                              _destextEditingController.text,
                              "${selectedDate.toIso8601String().substring(0, selectedDate.toString().indexOf(' '))}",
                              await SPHelper.spHelper.getUId());

                          await provider.sendNotificatonToallStudent(
                              provider.sec.id,
                              "${provider.teacher.name}  أضافت واجب منزلي جديد",
                              "");

                          await provider.addNotification(
                              "${provider.teacher.name} " +
                                  "أضافت واجب منزلي جديد",
                              await SPHelper.spHelper.getUId(),
                              provider.sec.id);
                          _loaded = false;
                          if (!mounted) return;
                          setState(() {});
                          Navigator.of(context).pop();
                        })
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      if (!mounted) return;
      setState(() {
        selectedDate = selected;
      });
    }
  }
}
