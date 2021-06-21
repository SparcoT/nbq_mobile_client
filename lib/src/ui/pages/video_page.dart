import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nbq_mobile_client/src/app.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

// ignore: must_be_immutable
class VideoPage extends StatefulWidget {
  final String url;
  String videoName;

  VideoPage({this.url, this.videoName});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  var playing = false;
  var loading = false;
  VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(widget.url);
    initializeVideo();
  }

  void initializeVideo() async {
    loading = true;
    setState(() {});

    controller.setLooping(true);
    await Wakelock.enable();
    await controller.initialize();
    await controller.play();
    loading = false;

    playing = true;
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    Widget bottomNavigationBar;
    if (loading) {
      child = Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CupertinoActivityIndicator(),
            SizedBox(height: 5),
            Text('Loading Video'),
          ]),
        ),
      );
    } else {
      child = VideoPlayer(controller);
      bottomNavigationBar = Container(
        height: 56,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, .4), blurRadius: 5)
        ]),
        child: Row(children: [
          SizedBox(width: 4),
          TextButton(
            onPressed: () async {
              if (playing) {
                playing = false;
                await controller.pause();
              } else {
                playing = true;
                await controller.play();
              }

              setState(() {});
            },
            child: Icon(
              playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
            ),
            style: TextButton.styleFrom(
              primary: Colors.black,
              padding: EdgeInsets.zero,
              minimumSize: Size(40, 40),
              backgroundColor: Colors.white.withOpacity(.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(width: 5),
          Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(17, 20, 17, 5),
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  padding: EdgeInsets.zero,
                  colors: VideoProgressColors(
                    playedColor: AppTheme.primaryColor,
                  ),
                ),
              ),
              Row(children: [
                if (!kIsWeb)
                  _UpdateProgress(controller: controller),
                Spacer(),
                Text(
                  '${_formatNumber(controller.value.duration.inMinutes)}:'
                  '${_formatNumber(controller.value.duration.inSeconds)}',
                  style: TextStyle(color: Colors.white),
                )
              ])
            ]),
          ),
          SizedBox(width: 10),
        ]),
      );
    }

    return Scaffold(
      body: child,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      bottomNavigationBar: bottomNavigationBar,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.videoName),
        actions: [
          if (!kIsWeb)
            IconButton(
              onPressed: () async {
                if (playing) await Share.share(widget.url);
              },
              icon: Icon(Icons.share_rounded),
            ),
        ],
      ),
    );
  }
}

String _formatNumber(int number) {
  if (number < 10) return '0$number';
  return number.toString();
}

class _UpdateProgress extends StatefulWidget {
  final VideoPlayerController controller;

  const _UpdateProgress({Key key, this.controller}) : super(key: key);

  @override
  __UpdateProgressState createState() => __UpdateProgressState();
}

class __UpdateProgressState extends State<_UpdateProgress> {
  var currentPosition = Duration();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(rebuild);
  }

  @override
  void didUpdateWidget(covariant _UpdateProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(rebuild);
    widget.controller.addListener(rebuild);
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(rebuild);
  }

  void rebuild() async {
    currentPosition = await widget.controller.position;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_formatNumber(currentPosition.inMinutes)}:'
      '${_formatNumber(currentPosition.inSeconds)}',
      style: TextStyle(color: Colors.white),
    );
  }
}
