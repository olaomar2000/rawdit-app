import 'package:arabi/src/models/homework.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'package:arabi/src/utils/constants.dart';

import '../../../notifiers/teacher_main_screen_notifiers.dart';
import '../../components/custom_btn_component.dart';
import '../../components/custom_text_field.dart';

class EditHomework extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String endDate;
  final String fileUrl;
  final String teacherId;
  EditHomework(
    this.id,
    this.title,
    this.description,
    this.endDate,
    this.fileUrl,
    this.teacherId,
  );

  @override
  State<EditHomework> createState() => _EditHomeworkState();
}

class _EditHomeworkState extends State<EditHomework> {
  TextEditingController _titletextEditingController = TextEditingController();
  TextEditingController _destextEditingController = TextEditingController();
  DateTime selectedDate;
  bool _loadingImg = false;
  bool _updating = false;
  @override
  void initState() {
    super.initState();
    _titletextEditingController.text = widget.title;
    _destextEditingController.text = widget.description;
  }

  @override
  void dispose() {
    _titletextEditingController.dispose();
    _destextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text('تعديل واجب'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Consumer<TeacherMainScreenNotifiers>(
          builder: (context, provider, x) {
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
                  height: 50,
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
                    TextButton(
                      onPressed: () async {
                        print('widget.fileUrl ${widget.fileUrl}');
                        await provider.showTheFile(widget.fileUrl, context);
                      },
                      child: Text(
                        '${widget.fileUrl == null && provider.name == null ? 'لا يوجد' : provider.getTheNameOfTheFile(widget.fileUrl == null ? provider.name : widget.fileUrl, isLandScape)}',
                        style: TextStyle(
                            color:
                                widget.fileUrl == null && provider.name == null
                                    ? Color(0xff707070)
                                    : customBlue,
                            fontSize: 18),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        provider.name = null;
                        _loadingImg = true;
                        setState(() {});
                        await provider.selectFile();
                        _loadingImg = false;
                        setState(() {});
                      },
                      icon: SvgPicture.asset(
                        '${Constants.ASSETS_IMAGES_PATH}attachment.svg',
                        width: 24,
                        height: 24,
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
                      child: selectedDate == null
                          ? Text("${provider.convertDateToAr(widget.endDate)}")
                          : Text(
                              "${provider.convertDateToAr(selectedDate.toIso8601String())}"),
                    ),
                    IconButton(
                      onPressed: () {
                        _selectDate(context);
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
                _loadingImg || _updating
                    ? Center(
                        child: CircularProgressIndicator(
                        color: customBlue,
                      ))
                    : CustomBtnComponent(
                        text: 'تعديل',
                        onTap: () async {
                          if (widget.title.trim() == "" ||
                              widget.description.trim() == "") {
                            toast(
                                'لا يمكن أن يكون العنوان أو الوصف قيمة فارغة');
                            return;
                          }

                          _updating = true;

                          setState(() {});

                          Homework hw = new Homework(
                              id: widget.id,
                              description: _destextEditingController.text,
                              title: _titletextEditingController.text,
                              endDate: selectedDate == null
                                  ? widget.endDate
                                  : selectedDate.toIso8601String(),
                              fileUrl: widget.fileUrl,
                              teacherId: widget.teacherId);

                          await provider.editHomework(hw);

                          _updating = false;
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

  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
