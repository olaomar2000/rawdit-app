import 'package:arabi/src/data/sp_helper.dart';
import 'package:arabi/src/themes/app_themes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const AdsScreenBody();
}

class AdsScreenBody extends StatefulWidget {
  const AdsScreenBody({Key key}) : super(key: key);

  @override
  _AdsScreenBodyState createState() => _AdsScreenBodyState();
}

class _AdsScreenBodyState extends State<AdsScreenBody> {
  List<Ads> adsList = [
    Ads(
        image: 'ad1.svg',
        description:
            'يمكنك تتبع وصول طفلك إلى رياض الأطفال من  خلال خاصية التتبع ',
        title: 'تتبع طفلك'),
    Ads(
        image: 'ad2.svg',
        description:
            'يمكنك متابعة شؤون طفلك وتسليم المهام  من خلال خاصية التسليمات ',
        title: 'تسليم الواجبات'),
    Ads(
        image: 'ad3.svg',
        description:
            'يمكنك متابعة شؤون طفلك والسؤال عنه  من خلال خاصية الدردشة',
        title: 'تحدث مع المعلم'),
  ];

  @override
  void initState() {
    super.initState();
    SPHelper.spHelper.setOnboarding(true);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    buttonCarouselController = CarouselController();
  }

  int _current = 0;
  CarouselController buttonCarouselController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: TextButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, Constants.SCREENS_USER_TYPE_SCREEN, (route) => false);
          },
          child: Text(
            'تخطي',
            style: TextStyle(color: customBlue),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: CarouselSlider(
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                    height: double.infinity,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
                items: adsList
                    .map((e) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: <Widget>[
                              SvgPicture.asset(
                                '${Constants.ASSETS_IMAGES_PATH}${e.image}',
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Center(
                                child: Text(
                                  e.title,
                                  style: const TextStyle(
                                    fontSize: 31,
                                    fontWeight: FontWeight.bold,
                                    color: customBlue,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  e.description,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: customBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),

                // AppShared.adsResponse.ads.length,
              ),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: _current == adsList.length - 1
                        ? InkWell(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Constants.SCREENS_USER_TYPE_SCREEN,
                                  (route) => false);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.done,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              setState(() {
                                _current++;
                              });
                              buttonCarouselController.nextPage();
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            )),
                  ),
                  Container(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: adsList.asMap().entries.map((entry) {
                          return GestureDetector(
                            child: Container(
                              width: 30.0,
                              height: 12.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                  // shape: BoxShape.circle,
                                  borderRadius: BorderRadius.circular(5),
                                  // border: Border.all(
                                  //     color: Theme.of(context).primaryColor
                                  // ),
                                  color: _current == entry.key
                                      ? Theme.of(context).primaryColor
                                      : Color(0xffA9C0E2)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class Ads {
  String image;
  String title;
  String description;
  Ads({this.image, this.title, this.description});
}
