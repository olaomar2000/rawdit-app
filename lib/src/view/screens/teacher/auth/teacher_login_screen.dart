import 'package:arabi/src/data/api_helper.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:arabi/src/view/components/custom_btn_component.dart';
import 'package:arabi/src/view/components/entry_field_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../../../themes/app_themes.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({Key key}) : super(key: key);

  @override
  _TeacherLoginScreenState createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  String _id = "";
  String _password = "";

  Future<void> _submit() async {
    final isValidate = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValidate) {
      _formKey.currentState.save();

      await ApiHelper.apiHelper
          .submitAuthForm(
              _password.trim(), _id.trim(), true, Constants.TEACHER_URL)
          .then((value) {
        if (value == "fail") {
          toast('رقم الهوية أو كلمة المرور غير صحيحة ');
        } else {
          Navigator.of(context)
              .pushNamed(Constants.SCREENS_TEACHER__MAIN_SCREEN);
          showSimpleNotification(Center(child: Text("تم تسجيل الدخول بنجاح ")),
              background: customBlue);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          //  mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            SvgPicture.asset(
              '${Constants.ASSETS_IMAGES_PATH}logo.svg',
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  EntryFieldComponent(
                    icon: 'id-field',
                    title: 'رقم الهوية',
                    key: ValueKey('username'),
                    validator: (val) {
                      if (val.isEmpty) {
                        return "أضف رقم الهوية";
                      }
                      return null;
                    },
                    onSaved: (val) => _id = val,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  EntryFieldComponent(
                    isSecure: true,
                    icon: 'lock',
                    title: 'كلمة السر',
                    key: ValueKey('password'),
                    validator: (val) {
                      if (val.isEmpty) {
                        return "أضف كلمة السر";
                      }
                      return null;
                    },
                    onSaved: (val) => _password = val,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  _loading
                      ? Center(child: CircularProgressIndicator())
                      : CustomBtnComponent(
                          text: 'تسجيل الدخول',
                          onTap: () async {
                            _loading = true;
                            if (!mounted) return;
                            setState(() {});
                            await _submit();
                            _loading = false;
                            if (!mounted) return;

                            setState(() {});

                            //  Navigator.of(context)
                            //     .pushNamed(Constants.SCREENS_TEACHER__MAIN_SCREEN);
                          },
                        ),
                ],
              ),
            ),
            Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          Constants.SCREENS_TEACHER_LOGIN_WITH_QR_SCREEN);
                    },
                    child: Text(
                      "تسجيل الدخول عن طريق QR",
                      style: TextStyle(color: customBlue, fontSize: 18),
                    ))),
          ],
        ),
      ),
    );
  }
}
