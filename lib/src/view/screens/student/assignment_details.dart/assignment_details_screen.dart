import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/models/submit.dart';
import 'package:arabi/src/notifiers/main_screen_notifiers.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:arabi/src/view/components/custom_btn_component.dart';
import 'package:arabi/src/view/screens/student/assignment_details.dart/custom_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'custom_card.dart';

class AssignmentDetailsScreen extends StatefulWidget {
  const AssignmentDetailsScreen({Key key}) : super(key: key);

  @override
  _AssignmentDetailsScreenState createState() =>
      _AssignmentDetailsScreenState();
}

class _AssignmentDetailsScreenState extends State<AssignmentDetailsScreen> {
  MainScreenNotifiers provider = Provider.of<MainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);
  Submit submitDetails;

  bool _theHwIsSubmitted = false;
  bool _missedTheDeadline = false;
  bool _loadingSubmit = true;
  bool _isUpload = false;
  bool _loadingPhoto = false;
  bool _exitFromTheScreen = false;

  Future<void> getMarkAndNode() async {
    submitDetails = await provider
        .getSubmitDetailForTheCurrentHW(provider.homeworkStudent.id);

    List<Submit> subList =
        await provider.getAllSumbmiters(provider.homeworkStudent.id) ?? [];
    String currentIdStd = await SPHelper.spHelper.getUId();
    subList.forEach((e) {
      if (e.stdId == currentIdStd) {
        _theHwIsSubmitted = true;
        if (!mounted) return;
        setState(() {});
        return;
      }
    });

    List<String> date;
    String hwDate = provider.homeworkStudent.endDate;
    if (hwDate.contains('T')) {
      hwDate = hwDate.substring(0, hwDate.indexOf('T'));
    } else if (hwDate.contains(' ')) {
      hwDate = hwDate.substring(0, hwDate.indexOf(' '));
    }
    if (hwDate.contains('-')) {
      date = hwDate.split('-');
    } else if (hwDate.contains('/')) {
      date = hwDate.split('/');
    }

    if (int.parse(date[1]) >= DateTime.now().month &&
        int.parse(date[2]) >= DateTime.now().day) {
      _missedTheDeadline = false;
    } else {
      _missedTheDeadline = true;
    }

    provider.readyTheUploadedImg = "";
    provider.name = null;
    provider.file = null;
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    if (_loadingSubmit) {
      getMarkAndNode().then((value) {
        if (!mounted) return;
        setState(() {
          _loadingSubmit = false;
        });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('الواجبات'),
        backgroundColor: customBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: _loadingSubmit
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: CustomCard(
                          provider: provider,
                        )),
                    const SizedBox(height: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomListTile(
                          isFirst: true,
                          title: 'الوصف : ',
                          description: provider.homeworkStudent.description,
                        ),
                        const SizedBox(height: 5),
                        CustomListTile(
                          isFirst: false,
                          title: 'تاريخ الإنتهاء : ',
                          description: provider.convertDateToAr(
                              provider.homeworkStudent.endDate),
                        ),
                        const SizedBox(height: 5),
                        CustomListTile(
                          isFirst: false,
                          title: ' العلامة : ',
                          description: submitDetails != null
                              ? submitDetails.mark.trim() == 'mark' ||
                                      submitDetails.mark.trim() == ''
                                  ? 'لم يتم رصد العلامة بعد'
                                  : submitDetails.mark
                              : _missedTheDeadline
                                  ? 'صفر'
                                  : 'لم يتم رصد العلامة بعد',
                        ),
                        const SizedBox(height: 5),
                        CustomListTile(
                          isFirst: false,
                          title: 'الملاحظة:',
                          description: submitDetails != null &&
                                  submitDetails.note != 'note'
                              ? submitDetails.note
                              : 'لا يوجد أي ملاحظات',
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: MediaQuery.of(context).size.width - 75,
                          color: Colors.grey[300],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                'الملفات المرفقة:',
                                style: const TextStyle(
                                    color: Color(0xff707070),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: provider.homeworkStudent.fileUrl !=
                                      'file'
                                  ? Hero(
                                      tag: provider.homeworkStudent.fileUrl,
                                      child: TextButton(
                                        onPressed: () async {
                                          await provider.showTheFile(
                                              provider.homeworkStudent.fileUrl,
                                              context);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${provider.homeworkStudent.fileUrl != 'file' ? "1 صفحة" : "لا يوجد أي مرفقات"}',
                                              style: TextStyle(
                                                color: provider.homeworkStudent
                                                            .fileUrl ==
                                                        'file'
                                                    ? null
                                                    : Color(0xff005FAD),
                                                fontSize: 19,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            provider.homeworkStudent.fileUrl !=
                                                    'file'
                                                ? Icon(Icons.folder,
                                                    color: Color(0xffAFC4E4))
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Text(
                                      "لا يوجد أي مرفقات",
                                      style: TextStyle(fontSize: 19),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: MediaQuery.of(context).size.width - 75,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                'الملفات المسلمة:',
                                style: const TextStyle(
                                    color: Color(0xff707070),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: _theHwIsSubmitted
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          child: Text(
                                            '${provider.getTheNameOfTheFile(submitDetails.file, isLandscape)}',
                                            style: TextStyle(
                                              color: Color(0xff005FAD),
                                              fontSize: 19,
                                            ),
                                          ),
                                          onPressed: () async {
                                            await provider.showTheFile(
                                                submitDetails.file, context);
                                          },
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            if (!_missedTheDeadline) {
                                              _loadingPhoto = true;
                                              provider.name = null;
                                              setState(() {});

                                              await provider.selectFile();
                                              if (provider.name != null) {
                                                provider.readyTheUploadedImg =
                                                    "";
                                                await provider.uploadFile();
                                              }
                                              _loadingPhoto = false;
                                              if (!mounted) return;
                                              setState(() {});
                                            }
                                          },
                                          icon: SvgPicture.asset(
                                            '${Constants.ASSETS_IMAGES_PATH}attachment.svg',
                                            width: 19,
                                            height: 19,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: _missedTheDeadline
                                              ? Text(
                                                  'غير متاح',
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      color: Color.fromARGB(
                                                          255, 75, 75, 75)),
                                                )
                                              : ElevatedButton(
                                                  onPressed: () async {
                                                    if (submitDetails != null &&
                                                        submitDetails.mark !=
                                                            'mark' &&
                                                        submitDetails.mark !=
                                                            '') {
                                                      await provider
                                                          .showTheFile(
                                                              submitDetails
                                                                  .file,
                                                              context);
                                                    } else {
                                                      _loadingPhoto = true;
                                                      provider.name = null;

                                                      setState(() {});

                                                      await provider
                                                          .selectFile();
                                                      if (provider.name !=
                                                          null) {
                                                        provider.readyTheUploadedImg =
                                                            "";
                                                        await provider
                                                            .uploadFile();
                                                      }
                                                      _loadingPhoto = false;
                                                      if (!mounted) return;
                                                      setState(() {});
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Colors.grey[300],
                                                    elevation: 0,
                                                  ),
                                                  child: Text(
                                                    '${provider.readyTheUploadedImg == "" ? "غير محدد" : provider.getTheNameOfTheFile(provider.readyTheUploadedImg, isLandscape)}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xff005FAD)),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: !_theHwIsSubmitted
                          ? Container(
                              height: 50,
                              width: 200,
                              child: _loadingPhoto
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color: customBlue,
                                      ),
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      )),
                                    )
                                  : _loadingPhoto
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : _missedTheDeadline
                                          ? Container()
                                          : ElevatedButton(
                                              onPressed: () async {
                                                if (_missedTheDeadline) {
                                                  toast(
                                                      'لقد انتهى موعد تسليم هذا الواجب');
                                                } else if (provider.name ==
                                                        null &&
                                                    provider.readyTheUploadedImg ==
                                                        "") {
                                                  // if he didn't upload any file, The second condition in case he upload a file then tried to upload other but cancel the request, in such a situation like that the provider.name will be null
                                                  toast(
                                                      'لا يمكنك التسليم بدون رفع أي ملف');
                                                } else
                                                  await showDialog<void>(
                                                    context: context,
                                                    barrierDismissible:
                                                        false, // user must tap button!
                                                    builder: (_) {
                                                      bool cliked = false;
                                                      return AlertDialog(
                                                        title: SvgPicture.asset(
                                                          '${Constants.ASSETS_IMAGES_PATH}Polygon.svg',
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                        content: Text(
                                                            'هل أنت متأكد من اضافة هذا التسليم؟'),
                                                        actions: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              ElevatedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          customBlue),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                      side: BorderSide(
                                                                          color:
                                                                              customBlue))),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                        'لا'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              ElevatedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          customBlue),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                      side: BorderSide(
                                                                          color:
                                                                              customBlue))),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                        'نعم'),
                                                                onPressed:
                                                                    () async {
                                                                  _exitFromTheScreen =
                                                                      true;

                                                                  toast(
                                                                      'انتظر قليلاً جاري اعتماد هذا التسليم ...');
                                                                  if (!cliked) {
                                                                    cliked =
                                                                        true;

                                                                    await provider.addSubmitAfterUploadTheImg(
                                                                        await SPHelper
                                                                            .spHelper
                                                                            .getUId(),
                                                                        "mark",
                                                                        "note",
                                                                        provider
                                                                            .homeworkStudent
                                                                            .id);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                if (_exitFromTheScreen)
                                                  Navigator.pop(context);
                                                if (!mounted) return;
                                                setState(() {});
                                              },
                                              child: Text("اضافة تسليم"),
                                              style: ElevatedButton.styleFrom(
                                                primary: _missedTheDeadline
                                                    ? Colors.grey
                                                    : Color(0xff005FAD),
                                              ),
                                            ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    child: _missedTheDeadline
                                        ? Container()
                                        : CustomBtnComponent(
                                            text: ' حذف التسليم ',
                                            onTap: () async {
                                              if (_missedTheDeadline) {
                                                toast("لقد انتهى موعد التسليم");
                                              } else if (submitDetails !=
                                                      null &&
                                                  submitDetails.mark !=
                                                      'mark') {
                                                toast(
                                                    'لا يمكنك اضافة أو تعديل هذا الواجب لان العلامة سبق رصدها');
                                              } else if (_loadingPhoto) {
                                                toast(
                                                    'انتظر الى حين انتهاء العملية الجارية');
                                              } else
                                                showDialog<void>(
                                                    context: context,
                                                    barrierDismissible:
                                                        false, // user must tap button!
                                                    builder:
                                                        (BuildContext context) {
                                                      bool clicked = false;
                                                      return AlertDialog(
                                                        title: SvgPicture.asset(
                                                          '${Constants.ASSETS_IMAGES_PATH}Polygon.svg',
                                                          width: 50,
                                                          height: 50,
                                                        ),
                                                        content: Text(
                                                            'هل أنت متأكد من حذف هذا التسليم؟'),
                                                        actions: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              ElevatedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          customBlue),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                      side: BorderSide(
                                                                          color:
                                                                              customBlue))),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                        'لا'),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                              ElevatedButton(
                                                                style:
                                                                    ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStateProperty.all<
                                                                              Color>(
                                                                          customBlue),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0),
                                                                      side: BorderSide(
                                                                          color:
                                                                              customBlue))),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                        'نعم'),
                                                                onPressed:
                                                                    () async {
                                                                  if (!clicked) {
                                                                    clicked =
                                                                        true;

                                                                    await provider
                                                                        .deleteSubmit(
                                                                            submitDetails.id);
                                                                    toast(
                                                                        'تم حذف التسليم بنجاح');
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    if (!mounted)
                                                                      return;
                                                                    setState(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    });
                                            },
                                          ),
                                  ),
                                ),
                                Expanded(
                                  child: _isUpload || _loadingPhoto
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : Container(
                                          height: 50,
                                          // color: _missedTheDeadline ? Colors.grey : null,
                                          child: _missedTheDeadline
                                              ? Container()
                                              : CustomBtnComponent(
                                                  text: 'تعديل التسليم',
                                                  onTap: () async {
                                                    if (_missedTheDeadline) {
                                                      toast(
                                                          "لقد انتهى موعد التسليم");
                                                    } else if (submitDetails !=
                                                            null &&
                                                        (submitDetails.mark !=
                                                                'mark' ||
                                                            submitDetails
                                                                    .mark ==
                                                                '')) {
                                                      toast(
                                                          "لا يمكنك إضافة أو تعديل هذا الواجب لان العلامة سبق رصدها");
                                                    } else if (provider
                                                            .readyTheUploadedImg ==
                                                        "") {
                                                      toast(
                                                          "لا يمكنك التعديل بدون رفع أي ملف جديد");
                                                    } else {
                                                      await showDialog<void>(
                                                          context: context,
                                                          barrierDismissible:
                                                              false, // user must tap button!
                                                          builder: (BuildContext
                                                              context) {
                                                            bool clicked =
                                                                false;
                                                            return AlertDialog(
                                                              title: SvgPicture
                                                                  .asset(
                                                                '${Constants.ASSETS_IMAGES_PATH}Polygon.svg',
                                                                width: 50,
                                                                height: 50,
                                                              ),
                                                              content: Text(
                                                                  'هل أنت متأكد من تعديل هذا التسليم؟'),
                                                              actions: <Widget>[
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all<Color>(customBlue),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            side: BorderSide(color: customBlue))),
                                                                      ),
                                                                      child: const Text(
                                                                          'لا'),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    ElevatedButton(
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all<Color>(customBlue),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            side: BorderSide(color: customBlue))),
                                                                      ),
                                                                      child: const Text(
                                                                          'نعم'),
                                                                      onPressed:
                                                                          () async {
                                                                        if (!clicked) {
                                                                          clicked =
                                                                              true;

                                                                          _isUpload =
                                                                              true;
                                                                          setState(
                                                                              () {});

                                                                          await provider
                                                                              .deleteSubmit(submitDetails.id);
                                                                          await provider.addSubmitAfterUploadTheImg(
                                                                              await SPHelper.spHelper.getUId(),
                                                                              "mark",
                                                                              "note",
                                                                              provider.homeworkStudent.id);
                                                                          _isUpload =
                                                                              false;
                                                                          if (!mounted)
                                                                            return;
                                                                          setState(
                                                                              () {});
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          toast(
                                                                              "تم التعديل بنجاح");
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        }
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    }
                                                  },
                                                )),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
