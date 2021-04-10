import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String url;

  VideoPage({this.url});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _chewieController = ChewieController(
        videoPlayerController: VideoPlayerController.network(widget.url)..initialize().then((_) {
          setState(() {});
          _controller.play();
        }),
        autoInitialize: true,
        autoPlay: true,
        looping: true,);
    //_controller = VideoPlayerController.network(widget.url)

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

 _chewieController.videoPlayerController.dispose();
  _chewieController.dispose();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video name'),
      ),
      body: Center(
        child: _chewieController.autoInitialize
            ? Stack(
                children: [
                  Chewie(controller: _chewieController),
//                VideoPlayer(_controller),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
