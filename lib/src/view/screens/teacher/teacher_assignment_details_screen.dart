import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:arabi/src/view/screens/teacher/assignment_confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/teacher_main_screen_notifiers.dart';

class TeacherAssignmentDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TeacherMainScreenNotifiers provider =
        Provider.of<TeacherMainScreenNotifiers>(context, listen: false);

    List<Color> color = [
      Colors.black,
      Colors.blue,
      Colors.brown,
      Colors.green,
      Colors.yellow,
      Colors.pink,
      Colors.orange
    ];
    color.shuffle();
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text('الواجبات'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: provider.homework == null
            ? Container(
                color: Colors.white,
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SvgPicture.asset(
                                  '${Constants.ASSETS_IMAGES_PATH}assignment-nav.svg',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              provider.homework.title,
                              style: TextStyle(color: Color(0xff707070)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الوصف : ',
                              style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              provider.homework.description,
                              style: TextStyle(
                                color: Color(0xff95989A),
                                fontSize: 19,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              'تاريخ الإنتهاء : ',
                              style: const TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              provider
                                  .convertDateToAr(provider.homework.endDate),
                              style: const TextStyle(
                                color: Color(0xff95989A),
                                fontSize: 19,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  ' الملفات : ',
                                  style: const TextStyle(
                                      color: Color(0xff707070),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await provider.showTheFile(
                                        provider.homework.fileUrl, context);
                                  },
                                  child: Text(
                                    provider.getTheNameOfTheFile(
                                        provider.homework.fileUrl, isLandscape),
                                    style: TextStyle(
                                      color: customBlue,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'تسليمات الواجب',
                      style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  provider.allSubmit.length == 0
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text('لا يوجد أي تسليمات بعد'),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return FutureBuilder(
                              future:
                                  provider.getStd(provider.allSubmit[i].stdId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        color: customBlue),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      '${snapshot.error} occured',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  );
                                }
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    onTap: () async {
                                      provider.sub = null;
                                      await provider.getSubmitDetalis(
                                          provider.allSubmit[i].id);
                                      ;
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              AssignmentConfirmScreen(
                                                  provider.allSubmit[i]),
                                        ),
                                      );
                                    },
                                    leading: CircleAvatar(
                                      radius: 25,
                                      child: Text(
                                        provider.std.name[0],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                        ),
                                      ),
                                      backgroundColor: color[i % color.length],
                                    ),
                                    title: Text(
                                      provider.std.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                            fontSize: 20,
                                            color: MainFontColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          itemCount: provider.allSubmit.length,
                        ),
                ]),
              ),
      ),
    );
  }
}
