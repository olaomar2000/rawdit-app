import 'package:arabi/src/notifiers/main_screen_notifiers.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:arabi/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdvertisementScreen extends StatefulWidget {
  const AdvertisementScreen({Key key}) : super(key: key);

  @override
  _AdvertisementScreenState createState() => _AdvertisementScreenState();
}

class _AdvertisementScreenState extends State<AdvertisementScreen> {
  MainScreenNotifiers provider = Provider.of<MainScreenNotifiers>(
      Constants.navKey.currentContext,
      listen: false);
  bool _loaded = false;
  Future<void> getData() async {
    await provider.getAllPost();
    await provider.getTeacherInfo();
  }

  ScrollController _hideButtonController;
  @override
  void dispose() {
    _hideButtonController.removeListener(() {
      provider.hideBottomBar();
    });
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    _hideButtonController = provider.scrollBottomBarController;
    provider.myScroll();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      getData().then((value) {
        _loaded = true;
        if (!mounted) return;
        setState(() {});
      });
    }
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text('الاعلانات'),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: !_loaded
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Column(
                children: [
                  AnimatedContainer(
                    height: !provider.hide
                        ? 0
                        : isLandscape
                            ? 0
                            : 120,
                    curve: Curves.fastOutSlowIn,
                    duration: Duration(milliseconds: 2000),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/Artboard.png"),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              " صف" +
                                  " " +
                                  provider.section.category +
                                  ' ' +
                                  provider.section.name,
                              style: TextStyle(
                                  color: customBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                 const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: _hideButtonController,
                      shrinkWrap: true,
                      itemCount: provider.allPostStudent.length,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: customRed,
                                      child: Text(
                                        provider.teacher.name[0],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'أ. ' + provider.teacher.name,
                                          style: TextStyle(
                                              color: Color(0xff707070),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                        Text(
                                          provider.convertDateToAr(provider
                                              .allPostStudent[index].date),
                                          style:const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 150, 150, 150),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                                Text(
                                  provider.allPostStudent[index].content,
                                  style:const TextStyle(
                                      color: Color(0xff707070),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      separatorBuilder: (BuildContext context, int index) =>
                       const   SizedBox(
                        height: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
