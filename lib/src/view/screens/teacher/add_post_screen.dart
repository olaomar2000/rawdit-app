import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/notifiers/teacher_main_screen_notifiers.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final myController = TextEditingController();
  bool _btnColorIsBlue = false;
  bool _load = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherMainScreenNotifiers>(
        builder: (context, provider, x) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffEEEBEB),
            centerTitle: true,
            title: Text(
              'إنشاء منشور',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor,
              ),
            ),
            actions: [
              _load
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : InkWell(
                      onTap: () async {
                        if (!myController.text.isEmpty) {
                          _load = true;
                          setState(() {});
                          await provider.addPost(myController.text,
                              await SPHelper.spHelper.getUId());
                          provider.sendNotificatonToallStudent(
                              provider.sec.id,
                              "اعلان جديد من ${provider.teacher.name}",
                              myController.text);

                          await provider.addNotification(
                              "${provider.teacher.name} " + myController.text,
                              await SPHelper.spHelper.getUId(),
                              provider.sec.id);
                          toast('تم نشر الاعلان بنجاح ',
                              duration: Duration(milliseconds: 90));
                          _load = false;
                          if (!mounted) return;
                          setState(() {});
                          await Navigator.of(context).pop();
                        } else {
                          toast('الرجاء تعبئة حقل المنشور أولا');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _btnColorIsBlue
                                ? customBlue
                                : Colors.grey[300]),
                        child: Center(
                          child: Text(
                            'نشر',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: _btnColorIsBlue
                                    ? Colors.white
                                    : const Color(0xff707070)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
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
                        child: Text(
                      provider.teacher.name,
                      style: TextStyle(
                          color: Color(0xff707070),
                          fontWeight: FontWeight.bold,
                          fontSize: 23),
                    ))
                  ],
                ),
                Expanded(
                    child: TextFormField(
                  textInputAction: TextInputAction.newline,
                  controller: myController,
                  maxLines: null,
                  onChanged: (txt) {
                    if (txt.length > 0) {
                      _btnColorIsBlue = true;
                    } else {
                      _btnColorIsBlue = false;
                    }
                    setState(() {});
                  },
                  decoration: InputDecoration(
                      hintText: 'بماذا تفكر ؟',
                      hintStyle: TextStyle(
                          color: Color(0xff707070),
                          fontWeight: FontWeight.bold,
                          fontSize: 23),
                      border: InputBorder.none),
                ))
              ],
            ),
          ));
    });
  }
}
