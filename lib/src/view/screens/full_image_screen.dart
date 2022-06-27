import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullImage extends StatelessWidget {
  const FullImage({Key key, this.src, this.tag}) : super(key: key);
  final String src;
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: Colors.white)),
      ),
      backgroundColor: Colors.black,
      body: Hero(
        tag: tag,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width / 1.5,
            child: PhotoView(
              imageProvider: NetworkImage(src),
            ),
          ),
        ),
      ),
    );
  }
}
