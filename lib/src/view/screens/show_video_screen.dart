import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

class ShowVideoScreen extends StatefulWidget {
  const ShowVideoScreen({Key key, this.src, this.tag}) : super(key: key);
  final String src;
  final String tag;

  @override
  State<ShowVideoScreen> createState() => _ShowVideoScreenState();
}

class _ShowVideoScreenState extends State<ShowVideoScreen> {
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.src)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back, color: Colors.white)),
      ),
      backgroundColor: Colors.black,
      body: Hero(
        tag: widget.tag,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width / 1.5,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
