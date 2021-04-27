import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
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
    //_controller = VideoPlayerController.network(widget.url)
    _initVideo();
  }
  _initVideo()async {
    final  videoController=VideoPlayerController.network(widget.url);
    await videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: videoController,
      autoInitialize: true,
      autoPlay: true,
      looping: true,
    );
    setState(() {

    });
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
        child: _chewieController?.isPlaying??false
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
