import 'dart:html';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nbq_mobile_client/src/ui/views/localized_view.dart';

Widget createImagePage({String image, String name, Widget imageWidget}) =>
    WebImagePage(
      name: name,
      image: image,
      imageWidget: imageWidget,
    );

class WebImagePage extends StatefulWidget {
  final String name;
  final String image;
  final Widget imageWidget;

  WebImagePage({this.name, this.image, this.imageWidget});

  @override
  _ImagePageWebState createState() => _ImagePageWebState();
}

class _ImagePageWebState extends State<WebImagePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LocalizedView(
      builder: (ctx, lang) =>
          Scaffold(
            appBar: AppBar(),
            key: _scaffoldKey,
            body: ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: InteractiveViewer(
                child: Center(
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null && child != null)
                        return child;
                      return CupertinoActivityIndicator();
                    },
                  ),
                ),
              ),
            ),
            persistentFooterButtons: [
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    AnchorElement()
                      ..href = widget.image
                      ..target = '_blank'
                      ..download = widget.name
                      ..click();

                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Image will be saved')),
                    );
                  },
                  icon: Icon(Icons.download_sharp),
                  label: Text(lang.download),
                ),
              ),
            ],
          ),
    );
  }
}
