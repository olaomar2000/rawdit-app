import 'package:flutter/material.dart';
class LoadingComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400 ,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // LoadingBouncingGrid.square(
          //   borderColor: Theme.of(context).primaryColor,
          //   backgroundColor: Theme.of(context).primaryColor,
          // ),
          SizedBox(
            height: 20 ,
          ),
          // Text(
          //   //'loading'
          //   AppShared.appLang['Loading']
          //   ),
        ],
      ),
    );
  }
}
