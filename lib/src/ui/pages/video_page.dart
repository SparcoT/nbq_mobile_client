import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String url;
  String videoName;

  VideoPage({this.url, this.videoName});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  // VideoPlayerController _controller;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(widget.url)
        ..initialize().then((_) async {
          // _controller.play();
          await _chewieController.play();
          setState(() {});
        }),
      autoInitialize: true,
      autoPlay: true,
      looping: true,
    );
    //_controller = VideoPlayerController.network(widget.url)
  }

  @override
  void dispose() {
    super.dispose();

    _chewieController.videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoName),
        actions: [
          TextButton(
            onPressed: () async {
              if (_chewieController.isPlaying) await Share.share(widget.url);
            },
            child: Icon(Icons.share),
          ),
        ],
      ),
      body: Center(
        child: _chewieController.isPlaying
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
