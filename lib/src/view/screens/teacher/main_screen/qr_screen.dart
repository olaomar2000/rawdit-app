import 'package:arabi/src/data/api_helper.dart';
import 'package:arabi/src/models/attendance.dart';
import 'package:arabi/src/models/student.dart';
import 'package:arabi/src/notifiers/teacher_main_screen_notifiers.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';

import '../../../../utils/constants.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({Key key}) : super(key: key);

  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  bool _loadingCam = true;
  students std;
  TeacherMainScreenNotifiers provider = Provider.of<TeacherMainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);

  Future<void> showAlert(String msg, bool done, String nameStd) async {
    await showDialog(
      context: context,
      barrierColor: customBlue.withOpacity(0.13),
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          content: Container(
            height: 150,
            child: Column(
              children: [
                SvgPicture.asset(
                  '${Constants.ASSETS_IMAGES_PATH}${done ? 'blue-check-mark.svg' : 'Polygon.svg'}',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 30),
                Text(
                  '$msg  $nameStd',
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
    );
  }

  @override
  void initState() {
    super.initState();
    startScanQR();
  }

  Future<void> startScanQR() async {
    // if (provider.studentInSecation == null) {
    await provider.getAllSection();
    await provider.getStudentInSecation(provider.sec.id);
    // }

    await scanQR();
    _loadingCam = false;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      await get(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
  }

  Future<void> get(String s) async {
    if (!mounted) return;
    students std = await ApiHelper.apiHelper.TakeAttendanceWithQr(s);

    if (std != null) {
      String date = DateTime.now().year.toString() +
          "/" +
          DateTime.now().month.toString() +
          "/" +
          DateTime.now().day.toString();
      Attendance exist =
          await ApiHelper.apiHelper.existAttendance(std.id, date);
      Attendance attendance = Attendance(
          id: exist != null ? exist.id : null,
          stdId: std.id,
          date: date,
          singout: exist != null ? true : false);

      if (exist != null) {
        await provider.editAttendance(attendance);
        await showAlert('تم تسجيل خروج', true, std.name);
      } else {
        await provider.addAttendance(attendance);
        await showAlert('تم تسجيل', true, std.name);
      }
    } else {
      await showAlert('لم يتم التعرف على هذا الطالب', false, '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR'),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _loadingCam
            ? CircularProgressIndicator()
            : ElevatedButton(
                child: Text(
                  '?Check again',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () async {
                  await scanQR();
                },
              ),
      ),
    );
  }
}
