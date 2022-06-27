import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../notifiers/main_screen_notifiers.dart';
import '../../../../utils/constants.dart';

class CustomCard extends StatelessWidget {
  final MainScreenNotifiers provider;

  const CustomCard({Key key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          child: Column(
            children: [
              Row(
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
                    provider.homeworkStudent.title,
                    style: TextStyle(color: Color(0xff707070)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
