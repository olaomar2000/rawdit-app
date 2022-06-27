import 'package:arabi/src/models/homework.dart';
import 'package:arabi/src/notifiers/main_screen_notifiers.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
// import 'package:arabi/src/view/screens/student/main_screen/main_screen.dart';
// import 'package:arabi/src/utils/fake_data.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({Key key}) : super(key: key);

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  MainScreenNotifiers _mainScreenNotifiers = Provider.of<MainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);

  bool _loaded = false;

  Future<void> initalData() async {
    await _mainScreenNotifiers.getAllHomeworkStudent();
    await _mainScreenNotifiers.getUnSubmittedHW();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      initalData().then((value) {
        _loaded = true;
        if (!mounted) return;
        setState(() {});
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('الواجبات'),
        backgroundColor: Color(0xff005FAD),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: !_loaded || _mainScreenNotifiers.submittedAndUnSubmittedHW == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: ListView(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'الواجبات',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                    
                    child: ExpansionTile(
                      iconColor: customBlue,
                      title: Text(
                        'الواجبات المنجزة',
                        style: TextStyle(
                            fontSize: 23,
                            color: customGrey,
                            fontWeight: FontWeight.bold),
                      ),
                      collapsedBackgroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      childrenPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      children: [
                        ...(_mainScreenNotifiers.submittedAndUnSubmittedHW[
                                    'submittedIdsHw'] ??
                                [])
                            .map(
                          (e) => InkWell(
                            onTap: () async {
                              _mainScreenNotifiers.homeworkStudent = null;
                              _mainScreenNotifiers.name = null;
                              _mainScreenNotifiers.file = null;
                              _mainScreenNotifiers.platformFile = null;
                              await _mainScreenNotifiers
                                  .getHomeworkDetalis(e.id);
                              await Navigator.of(context)
                                  .pushNamed(Constants
                                      .SCREENS_ASIGNMENT_DETAILS_SCREEN)
                                  .then((_) async {
                                await initalData();
                                if (!mounted) return;

                                setState(() {});
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        child: Image.asset(
                                            Constants.ASSETS_IMAGES_PATH +
                                                'Done HW.png'),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${e.title}  ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: customGrey),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'تاريخ الانتهاء : ${_mainScreenNotifiers.convertDateToAr(e.endDate)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    255, 138, 138, 138),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Image.asset(Constants.ASSETS_IMAGES_PATH +
                                          'Check.png')
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // AssignmentComponent(
                          //   item: e,
                          //   path: Constants.ASSETS_IMAGES_PATH + 'Done HW.png',
                          //   icon: Constants.ASSETS_IMAGES_PATH + 'Check.png',
                          //   f: initalData(),
                          // ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: ExpansionTile(
                      iconColor: customBlue,
                      title: const Text(
                        'الواجبات قيد التنفيذ',
                        style: TextStyle(
                          fontSize: 23,
                          color: customGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      collapsedBackgroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      childrenPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      children: [
                        ...(_mainScreenNotifiers.submittedAndUnSubmittedHW[
                                    'unSubmittedHwIds'] ??
                                [])
                            .map(
                          (e) => InkWell(
                            onTap: () async {
                              _mainScreenNotifiers.homeworkStudent = null;
                              _mainScreenNotifiers.name = null;
                              _mainScreenNotifiers.file = null;
                              _mainScreenNotifiers.platformFile = null;
                              await _mainScreenNotifiers
                                  .getHomeworkDetalis(e.id);
                              await Navigator.of(context)
                                  .pushNamed(Constants
                                      .SCREENS_ASIGNMENT_DETAILS_SCREEN)
                                  .then((_) async {
                                await initalData();
                                if (!mounted) return;
                                setState(() {});
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        child: Image.asset(
                                            Constants.ASSETS_IMAGES_PATH +
                                                'HW.png'),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${e.title}  ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: customGrey),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'تاريخ الانتهاء : ${_mainScreenNotifiers.convertDateToAr(e.endDate)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    255, 138, 138, 138),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    child: ExpansionTile(
                      iconColor: customBlue,
                      title: Text(
                        'الواجبات  الغير المنجزة',
                        style: TextStyle(
                            fontSize: 23,
                            color: customGrey,
                            fontWeight: FontWeight.bold),
                      ),
                      collapsedBackgroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      childrenPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      children: [
                        ...(_mainScreenNotifiers.submittedAndUnSubmittedHW[
                                    'missedHandingHwIds'] ??
                                [])
                            .map(
                          (e) => AssignmentComponent(
                            item: e,
                            path:
                                Constants.ASSETS_IMAGES_PATH + 'Un done HW.png',
                            icon: Constants.ASSETS_IMAGES_PATH + 'Close.png',
                            f: initalData(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class AssignmentComponent extends StatefulWidget {
  final Homework item;
  final String path;
  final String icon;
  final Future<void> f;
  AssignmentComponent({Key key, this.item, this.path, this.icon, this.f})
      : super(key: key);

  @override
  State<AssignmentComponent> createState() => _AssignmentComponentState();
}

class _AssignmentComponentState extends State<AssignmentComponent> {
  MainScreenNotifiers provider = Provider.of<MainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        provider.homeworkStudent = null;
        provider.name = null;
        provider.file = null;
        provider.platformFile = null;
        await provider.getHomeworkDetalis(widget.item.id);
        await Navigator.of(context)
            .pushNamed(Constants.SCREENS_ASIGNMENT_DETAILS_SCREEN)
            .then((_) async {
          await widget.f;
          if (!mounted) return;

          setState(() {});
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Image.asset(widget.path),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.item.title}  ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: customGrey),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'تاريخ الانتهاء : ${provider.convertDateToAr(widget.item.endDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 138, 138, 138),
                        ),
                      ),
                    ],
                  ),
                ),
                widget.icon == '' ? Container() : Image.asset(widget.icon)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
