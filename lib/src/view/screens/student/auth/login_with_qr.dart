import 'package:arabi/src/data/api_helper.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:overlay_support/overlay_support.dart';

class LoginWithQRScreen extends StatefulWidget {
  const LoginWithQRScreen({Key key}) : super(key: key);

  @override
  _LoginWithQRScreenState createState() => _LoginWithQRScreenState();
}

class _LoginWithQRScreenState extends State<LoginWithQRScreen> {
  String _scanBarcode = '';

  @override
  void initState() {
    super.initState();
    startScanQR();
  }

  Future<void> startScanQR() async {
    await scanQR();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      await get(barcodeScanRes);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
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
        child: _scanBarcode == ''
            ? CircularProgressIndicator()
            : TextButton(
                child: Text(
                    'Wrong login details click here to back and try again with your identifier number'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
      ),
    );
  }

  Future<void> get(String s) async {
    if (!mounted) return;
    bool v = await ApiHelper.apiHelper.logStudentWithQr(s);

    if (v == true) {
      if (!mounted) return;

      await showSimpleNotification(Text("أهلا بك في تطبيق روضتي "),
          background: customBlue);
      Navigator.of(context).pushNamedAndRemoveUntil(
          Constants.SCREENS_MAIN_SCREEN, (Route<dynamic> route) => false);
    }
  }
}
