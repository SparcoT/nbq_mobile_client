import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';

class ImagePage extends StatefulWidget {
  final String image;

  ImagePage({this.image});

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  // var _show = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.image,
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ImageWidget(
              src: widget.image,
              // onLoad: () => setState(() => _show = false),
            ),
            // if (_show)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () async {
                    await Permission.requestPermissions(
                        [PermissionName.Storage]);
                    var dir = await getExternalStorageDirectory();
                    var folderDir = Directory(dir.path + '/NBQ');
                    if (!folderDir.existsSync()) {
                      folderDir.create(recursive: true);
                    }
                    final _response = await Dio().download(
                        widget.image,
                        folderDir.path +
                            '/${DateTime.now().microsecondsSinceEpoch}.png');
                    _scaffoldKey.currentState
                        .showSnackBar(SnackBar(content: Text('Saved!')));
                    print(_response.data.toString());
                  },
                  icon: Icon(Icons.download_sharp),
                  label: Text('Download'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  final String src;
  final Function onLoad;

  _ImageWidget({this.onLoad, this.src});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      panEnabled: true,
      child: Image.network(
        src,
        fit: BoxFit.fitWidth,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            // onLoad();
            return child;
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
