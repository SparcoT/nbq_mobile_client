import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';
import 'package:share/share.dart';

class ImagePage extends StatefulWidget {
  final String image;
  final Widget imageWidget;

  ImagePage({this.image, this.imageWidget});

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  final imageName = Directory.systemTemp.path +
      '/' +
      DateTime.now().millisecondsSinceEpoch.toString() +
      '.png';

  var loading = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Dio()
        .download(widget.image, imageName)
        .then((value) => setState(() => loading = false));
  }

  @override
  void dispose() {
    super.dispose();

    File(imageName).delete();
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (ctx, lang) => Scaffold(
        appBar: AppBar(),
        key: _scaffoldKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              Center(child: CircularProgressIndicator())
            else ...[
              Image.file(File(imageName)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () async {
                      GallerySaver.saveImage(imageName).then((_) {
                        _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Image saved')));
                      });
                    },
                    icon: Icon(Icons.download_sharp),
                    label: Text(lang.download),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  final String src;
  final String tag;
  final Widget image;
  final Function onLoad;

  _ImageWidget({this.tag, this.onLoad, this.src, this.image});

  @override
  Widget build(BuildContext context) {
    print('tag: $tag');
    return InteractiveViewer(
      panEnabled: true,
      child: Hero(
        tag: tag,
        child: Image.network(
          src,
          height: 500,
          fit: BoxFit.fitWidth,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return image;
          },
        ),
      ),
    );
  }
}
