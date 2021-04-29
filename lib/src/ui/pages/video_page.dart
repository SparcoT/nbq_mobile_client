import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class VideoPage extends StatefulWidget {
  final String url;
  final String videoName;
  final String image;

  VideoPage({this.url, this.videoName, this.image});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  var _isLoading = true;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.url,
        videoPlayerOptions: VideoPlayerOptions());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.initialize().then((value) {
        setState(() => _isLoading = false);
        _controller.play();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoName),
      ),
      body: Stack(children: [
        if (_isLoading) ...[
          Image.network(
            widget.image,
            fit: BoxFit.fitWidth,
            color: Colors.white.withOpacity(.3),
            colorBlendMode: BlendMode.modulate,
          ),
//          Center(child: CircularProgressIndicator()),
        ] else
          AspectRatio(
            aspectRatio: 1 /3 ,
            child: VideoPlayer(_controller),
          ),
      ]),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
