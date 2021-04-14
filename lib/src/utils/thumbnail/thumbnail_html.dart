import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

Future<Uint8List> getVideoThumbnail(final String path) {
  if (!kIsWeb) throw 'No Supported on Platforms other than web';
  final memoryImage = Completer<Uint8List>();

  final video = VideoElement()..src = path;
  video.onLoadedMetadata.listen((event) async {
    video.volume = 0;
    video.width = video.videoWidth;
    video.height = video.videoHeight;
    video.currentTime = video.duration * 0.1;
    await video.play();

    final canvas =
    CanvasElement(width: video.width, height: video.height);
    canvas.context2D.drawImage(video, 0, 0);

    video.pause();
    memoryImage.complete(base64Decode(canvas.toDataUrl().substring(22)));
  });

  return memoryImage.future;
}